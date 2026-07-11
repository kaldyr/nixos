//@ pragma UseQApplication
//@ pragma IconTheme Papirus-Dark
// vim:fdm=marker:fdl=0:foldmarker=-->,<--

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
// import Quickshell.Services.UPower
import Quickshell.Widgets
import Quickshell.Io
import QtQuick

PanelWindow {
	id: root

	anchors {
		top:   true
		left:  true
		right: true
	}

	implicitHeight: 32
	color:  "transparent"

	readonly property string fontFamily: "Maple Mono NF"

	SystemClock {
		id:        sysClock
		precision: SystemClock.Seconds
	}

	// Controls
	// Hyprsunset    -->
	Singleton {
		id: hyprsunsetControl

		property bool isActive: true

		function toggle() {
			if (this.isActive) {
				this.isActive = false
				Quickshell.execDetached(["sh", "-c", "systemctl --user stop hyprsunset.service"])
			} else {
				this.isActive = true
				Quickshell.execDetached(["sh", "-c", "systemctl --user start hyprsunset.service"])
			}
		}

		Process {
			id:      hyprsunsetStateProcess
			running: true
			command: ["sh", "-c", "systemctl --user is-active hyprsunset.service"]
			stdout:  StdioCollector {
				onStreamFinished: {
					hyprsunsetControl.isActive = (this.text.trim() === "active")
				}
			}
		}

		Timer {
			interval:    1000
			running:     true
			repeat:      true
			onTriggered: hyprsunsetStateProcess.running = true
		}
	} // <--
	// Hypridle      -->
	Singleton {
		id: hypridleControl

		property bool isActive: true

		function toggle() {
			if (this.isActive) {
				this.isActive = false
				Quickshell.execDetached(["sh", "-c", "systemctl --user stop hypridle.service"])
			} else {
				this.isActive = true
				Quickshell.execDetached(["sh", "-c", "systemctl --user start hypridle.service"])
			}
		}

		Process {
			id:      hypridleStateProcess
			running: true
			command: ["sh", "-c", "systemctl --user is-active hypridle.service"]
			stdout:  StdioCollector {
				onStreamFinished: {
					hypridleControl.isActive = (this.text.trim() === "active")
				}
			}
		}

		Timer {
			interval:    1000
			running:     true
			repeat:      true
			onTriggered: hypridleStateProcess.running = true
		}
	} // <--
	// Notifications -->
	Singleton {
		id: notificationControl

		property bool isActive:   true
		property bool hasWaiting: false

		function toggle() {
			if (this.isActive) {
				this.isActive = false
				Quickshell.execDetached(["sh", "-c", "dunstctl set-paused true"])
			} else {
				this.isActive = true
				Quickshell.execDetached(["sh", "-c", "dunstctl set-paused false"])
			}
		}

		Process {
			id:      notificationStateProcess
			running: true
			command: ["sh", "-c", "dunstctl get-pause-level"]
			stdout:  StdioCollector {
				onStreamFinished: {
					const output = this.text.trim()
					if (output === "0") {
						notificationControl.isActive = true
					} else {
						notificationControl.isActive = false
					}
				}
			}
		}

		Process {
			id:      notificationWaitingProcess
			running: true
			command: ["sh", "-c", "dunstctl count waiting"]
			stdout:  StdioCollector {
				onStreamFinished: {
					const output = this.text.trim()
					if (output === "0") {
						notificationControl.hasWaiting = false
					} else {
						notificationControl.hasWaiting = true
					}
				}
			}
		}

		Timer {
			interval:    1000
			running:     true
			repeat:      true
			onTriggered: {
				notificationStateProcess.running = true
				notificationWaitingProcess.running = true
			}
		}
	} // <--

	// Colorscheme -->
	property var theme: ({
		bar: ({
			bg:       "#303446",
			border:   "#232634",
			alt:      "#292c3c",
		}),
		ws: ({
			active:   "#81c8be",
			inactive: "#8caaee",
			urgent:   "#e78284",
			empty:    "#414559",
			overview: "#babbf1",
		}),
		clock: ({
			bg:       "#292c3c",
			border:   "#ca9ee6",
			hands:    "#8caaee",
			text:     "#c6d0f5",
		}),
		cal: ({
			bg:       "#292c3c",
			border:   "#ef9f76",
			text:     "#c6d0f5",
		}),
		sunset: ({
			active:   "#ef9f76",
			inactive: "#414559",
		}),
		idle: ({
			active:   "#85c1dc",
			inactive: "#414559",
		})
	}) // <--

	// Left        -->  Launcher, Workspaces, Overview
	Rectangle { // Launcher button
		id: launcher

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           parent.left

		implicitHeight:    parent.height
		implicitWidth:     parent.height + 4
		topRightRadius:    this.height / 2
		bottomRightRadius: this.height / 2
		bottomLeftRadius:  this.height / 2
		color:             root.theme.bar.alt
		border.color:      root.theme.bar.border
		border.width:      2
		z:                 2

		IconImage {
			anchors.centerIn: parent

			source: Quickshell.iconPath("distributor-logo-nixos")
			height: 24
			width:  24
			smooth: true
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked:    Hyprland.dispatch("hl.dsp.exec_cmd('fuzzel')")
		}
	}

	Rectangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           launcher.right
		anchors.leftMargin:     -6

		implicitHeight:    parent.height - 10
		implicitWidth:     workspaces.width + 16
		topRightRadius:    this.height / 2
		bottomRightRadius: this.height / 2
		color:             root.theme.bar.bg
		border.color:      root.theme.bar.border
		border.width:      2
		opacity:           0.98

		Row {
			id: workspaces

			anchors.verticalCenter: parent.verticalCenter
			anchors.left:           parent.left
			anchors.leftMargin:     8

			readonly property var hyprWS: {
				let ws = []
				const open = Hyprland.workspaces.values
				for (let i = 1; i <= 10; i++)
					if (open[i] == i)
						ws.push(Hyprland.workspaces.values.find(w => w.id === i))
					else
						ws.push('')
				return ws
			}

			WheelHandler {
				acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

				onWheel: function(e) {
					if (e.angleDelta.y > 0) {
						Hyprland.dispatch("hl.dsp.focus({workspace = 'e-1'})")
					} else {
						Hyprland.dispatch("hl.dsp.focus({workspace = 'e+1'})")
					}
				}
			}

			Repeater { // Workspace Buttons
				model: workspaces.hyprWS

				Rectangle {
					anchors.verticalCenter: parent.verticalCenter

					implicitHeight: parent.height - 10
					implicitWidth:  14
					color:          "transparent"

					MouseArea {
						anchors.fill: parent
						onClicked:    Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
					}

					Rectangle {
						property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)

						property bool isActive: (ws.focused || false)
						property bool isUrgent: (ws.urgent || false)

						anchors.centerIn: parent

						implicitHeight: {
							if (isActive) { return 12 }
							if (isUrgent) { return 10 }
							if (ws)       { return 8 }
							return 4
						}

						implicitWidth:  this.height
						radius: this.height / 2

						color: {
							if (isUrgent) { return root.theme.ws.urgent }
							if (isActive) { return root.theme.ws.active }
							if (ws)       { return root.theme.ws.inactive }
							return root.theme.ws.empty
						}
					}
				}
			}

			Rectangle { // Overview
				anchors.verticalCenter: workspaces.verticalCenter

				implicitHeight: 20
				implicitWidth:  20
				color:          "transparent"

				Text {
					anchors.centerIn: parent

					font { family: root.fontFamily; pixelSize: 18; }

					color: root.theme.ws.overview
					text:  "󱒉"

					// MouseArea {
					// 	anchors.fill: parent
					// 	hoverEnabled: true
					// 	onClicked:
					// }
				}
			}
		}
	} // <--
	// LeftMid     -->  Volume, Media Controls
	// <--
	// Center      -->  Brightness, Hyprsunset, Clock, Time, Date, Calendar, Hypridle, Notifications
	Rectangle { // Left Toggles
		id: leftToggleBar
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          clockFace.left
		anchors.rightMargin:    -6

		implicitHeight:    parent.height - 10
		implicitWidth:     leftToggleButtons.width + 24
		topLeftRadius:     this.height / 2
		bottomLeftRadius:  this.height / 2
		color:             root.theme.bar.bg
		border.color:      root.theme.bar.border
		border.width:      2

		Row {
			id: leftToggleButtons

			anchors.verticalCenter: parent.verticalCenter
			anchors.right:          parent.right
			anchors.rightMargin:    12

			spacing: 6

			Rectangle { // Brightness
				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: leftToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				IconImage {
					anchors.centerIn: parent

					height: 12
					width:  12
					source: Quickshell.iconPath('brightnesssettings')
				}
			}

			Rectangle { // Hyprsunset
				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: leftToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				Text {
					anchors.centerIn: parent
					font { family: root.fontFamily; pixelSize: 13; }

					color: {
						if (hyprsunsetControl.isActive) {
							return root.theme.sunset.active
						}
						return root.theme.sunset.inactive
					}
					text:  ""

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						onClicked:    hyprsunsetControl.toggle()
					}
				}
			}
		}
	}

	Rectangle { // Clock
		id: clockFace

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          datetime.left
		anchors.rightMargin:    -5

		implicitHeight: parent.height - 2
		implicitWidth:  parent.height - 1
		radius:         this.height / 2
		color:          root.theme.clock.bg
		border.color:   root.theme.bar.border
		border.width:   2
		z:              2

		Canvas {
			anchors.fill: parent
			antialiasing: true

			onPaint: {
				const ctx = getContext("2d")
				const cx  = parent.width / 2
				const cy  = parent.height / 2
				const r   = Math.min( parent.width, parent.height ) / 2 - 2
				ctx.reset()
				ctx.strokeStyle = root.theme.clock.border
				ctx.globalAlpha = 0.5

				ctx.lineWidth = 0.8
				ctx.beginPath()
				ctx.arc(cx, cy, r, 0, 2 * Math.PI)
				ctx.stroke()

				for (let i = 0; i < 12; i++) {
					const isOrth    = i % 3 === 0
					const angle     = i * 30 * Math.PI / 180
					const inner     = r - (isOrth ? 5 : 3)
					const outer     = r
					ctx.globalAlpha = isOrth ? 1 : 0.5
					ctx.lineWidth   = 1
					ctx.beginPath()
					ctx.moveTo( cx + inner * Math.sin(angle), cy - inner * Math.cos(angle) )
					ctx.lineTo( cx + outer * Math.sin(angle), cy - outer * Math.cos(angle) )
					ctx.stroke()
				}
				ctx.globalAlpha = 1;
			}
		}
		Rectangle { // Minute Hand
			anchors.bottom:           clockFace.verticalCenter
			anchors.horizontalCenter: clockFace.horizontalCenter

			implicitHeight:  12
			implicitWidth:   1
			color:           root.theme.clock.hands
			antialiasing:    true
			transformOrigin: Item.Bottom
			rotation: {
				const d = sysClock.date;
				return d.getMinutes() * 6;
			}

			Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
		}

		Rectangle { // Hour Hand
			anchors.bottom:           clockFace.verticalCenter
			anchors.horizontalCenter: clockFace.horizontalCenter

			implicitHeight:  7
			implicitWidth:   2
			color:           root.theme.clock.hands
			antialiasing:    true
			transformOrigin: Item.Bottom
			rotation: {
				const d = sysClock.date;
				return ((d.getHours() % 12) + (d.getMinutes() / 60)) * 30;
			}

			Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
		}
	}

	Rectangle { // Center Bar
		id: datetime

		anchors.centerIn: parent

		implicitHeight: parent.height - 10
		implicitWidth:  180
		color:          root.theme.bar.bg
		border.color:   root.theme.bar.border
		border.width:   2

		Row {
			anchors.centerIn: parent

			Text { // Time
				id: time

				anchors.verticalCenter: parent.verticalCenter

				font { family: root.fontFamily; pixelSize: 12; }

				color: root.theme.clock.text
				text:  Qt.formatDateTime( sysClock.date, "HH:mm" )
			}

			Rectangle { // Spacer
				height: parent.height
				implicitWidth:  22
				color:  "transparent"
			}

			Text { // Date
				id: date

				anchors.verticalCenter: parent.verticalCenter

				font { family: root.fontFamily; pixelSize: 12; }

				color: root.theme.cal.text
				text:  Qt.formatDateTime( sysClock.date, "ddd, MMM dd" )
			}
		}
	}

	Rectangle { // Calendar
		id: calendar

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           datetime.right
		anchors.leftMargin:     -5

		implicitHeight: parent.height - 2
		implicitWidth:  parent.height - 1
		radius:         this.height / 2
		color:          root.theme.bar.alt
		border.color:   root.theme.bar.border
		border.width:   2
		z:              2

		IconImage {
			anchors.centerIn: parent

			height: 15
			width:  15
			source: Quickshell.iconPath('calendar')
		}
	}

	Rectangle { // Right Toggles
		id: rightToggleBar

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           calendar.right
		anchors.leftMargin:     -6

		implicitHeight:    parent.height - 10
		implicitWidth:     rightToggleButtons.width + 24
		topRightRadius:    this.height / 2
		bottomRightRadius: this.height / 2
		color:             root.theme.bar.bg
		border.color:      root.theme.bar.border
		border.width:      2

		Row {
			id: rightToggleButtons

			anchors.verticalCenter: parent.verticalCenter
			anchors.right:          parent.right
			anchors.rightMargin:    12

			spacing: 6

			Rectangle { // Hypridle
				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: rightToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				Text {
					anchors.centerIn: parent
					font { family: root.fontFamily; pixelSize: 12; }

					color: {
						if (hypridleControl.isActive) {
							return root.theme.idle.inactive
						}
						return root.theme.idle.active
					}
					text:  {
						if (hypridleControl.isActive) {
							return "󰾪"
						}
						return ""
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						onClicked:    hypridleControl.toggle()
					}
				}
			}

			Rectangle { // Notifications
				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: rightToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				IconImage {
					anchors.centerIn: parent

					height: 12
					width:  12
					source: {
						if (notificationControl.isActive) {
							return Quickshell.iconPath('notification-inactive')
						} else {
							if (notificationControl.hasWaiting) {
								return Quickshell.iconPath('notification-active')
							}
							return Quickshell.iconPath('notification-disabled')
						}
					}
				}

				MouseArea {
					anchors.fill:    parent
					hoverEnabled:    true
					acceptedButtons: Qt.LeftButton | Qt.RightButton

					onClicked: (m) => m.button === Qt.RightButton
						? Quickshell.execDetached(["dunstctl", "close-all"])
						: notificationControl.toggle()
				}

				WheelHandler {
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

					onWheel: function(e) {
						if (e.angleDelta.y > 0) {
							Quickshell.execDetached(["dunstctl", "history-pop"])
						} else {
							Quickshell.execDetached(["dunstctl", "close"])
						}
					}
				}
			}
		}
	} // <--
	// RightMid    -->  Network, Bluetooth
	// <--
	// Right       -->  System Tray, Power Menu
	Rectangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          parent.right

		height:           parent.height - 8
		width:            rightBar.width + 16
		topLeftRadius:    this.height / 2
		bottomLeftRadius: this.height / 2
		color:            root.theme.bar.bg
		border.color:     root.theme.bar.border
		border.width:     2
		opacity:          0.98

		Row {
			id: rightBar

			anchors.centerIn: parent

			spacing: 4

			Repeater {
				model: SystemTray.items

				Item {
					id: trayItem

					anchors.verticalCenter: parent.verticalCenter

					implicitHeight: 16
					implicitWidth:  20

					required property var modelData

					IconImage {
						anchors.verticalCenter: parent.verticalCenter
						anchors.left:           parent.left

						implicitHeight: parent.height
						implicitWidth:  parent.height
						source:         trayItem.modelData.icon
						smooth:         true
					}

					MouseArea {
						anchors.fill: parent

						hoverEnabled:    true
						acceptedButtons: Qt.LeftButton | Qt.RightButton

						onClicked: (m) => m.button === Qt.RightButton
							? trayItem.modelData.display(root, root.width - 24, rightBar.height + 12)
							: trayItem.modelData.activate()
					}
				}
			}
		}
	} // <--
}

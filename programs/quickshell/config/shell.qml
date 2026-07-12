// Quickshell bar for Hyprland
// vim:fdm=marker:fdl=0:foldmarker=-->,<--
//@ pragma UseQApplication
//@ pragma IconTheme Papirus-Dark
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
// import Quickshell.Services.UPower
import Quickshell.Widgets
import Quickshell.Io
import QtQuick

// qmllint disable uncreatable-type
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

	// Colorscheme   -->
	property var theme: ({
		bar: ({
			bg:       "#303446",
			border:   "#232634",
			alt:      "#292c3c",
			fill:     "#c6d0f5",
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

	// Left          -->  Launcher, Workspaces, Overview
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
				onWheel:         (e) => e.angleDelta.y > 0
					? Hyprland.dispatch("hl.dsp.focus({workspace = 'e-1'})")
					: Hyprland.dispatch("hl.dsp.focus({workspace = 'e+1'})")
			}

			Repeater { // Workspace Buttons
				model: workspaces.hyprWS

				Rectangle {
					id: wsButton
					anchors.verticalCenter: parent.verticalCenter

					required property int index

					implicitHeight: parent.height - 10
					implicitWidth:  14
					color:          "transparent"

					MouseArea {
						anchors.fill: parent
						onClicked:    Hyprland.dispatch("hl.dsp.focus({workspace = " + (wsButton.index + 1) + "})")
					}

					Rectangle {
						property var ws: Hyprland.workspaces.values.find(w => w.id === wsButton.index + 1) ?? null

						property bool isActive: this.ws?.focused ?? false
						property bool isUrgent: this.ws?.urgent ?? false

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
	// LeftMid       -->  Volume, Media Controls
	// <--
	// Center        -->  Brightness, Hyprsunset, Clock, Time, Date, Calendar, Hypridle, Notifications
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
				id: brightnessControl
				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: leftToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				property int  brightness: 100

				Process {
					id:      brightnessLevelProcess
					running: true
					command: ["sh", "-c", "brightnessctl -m | awk -F, '{print $2 \",\" $3 \",\" $5}'"]
					stdout:  StdioCollector {
						onStreamFinished: {
							const output = this.text.trim().split(',')
							brightnessTimer.interval = (output[0] === "backlight")
								? 1000
								: 10000
							brightnessControl.brightness = (output[0] === "backlight")
								? (output[1]/output[2])*100
								: 100
						}
					}
				}

				Timer {
					id:          brightnessTimer
					interval:    1000
					running:     true
					repeat:      true
					onTriggered: {
						brightnessLevelProcess.running =  true
					}
				}

				IconImage {
					id: brightnessIcon
					anchors.verticalCenter: parent.verticalCenter
					anchors.right:          parent.right
					anchors.rightMargin:    4

					height: 12
					width:  12
					source: Quickshell.iconPath('brightnesssettings')
				}

				Rectangle {
					anchors.verticalCenter: parent.verticalCenter
					anchors.right:          parent.left

					implicitHeight: 20
					implicitWidth:  118
					radius:         this.height / 2
					color:          root.theme.bar.bg
					border.color:   root.theme.bar.border
					border.width:   2
					opacity:        brightnessPointer.hovered ? 1 : 0
					visible:        opacity > 0
					z:              3

					Rectangle {
						anchors.centerIn: parent
						implicitHeight:   6
						implicitWidth:    102
						radius:           this.height / 2
						color:            root.theme.bar.alt
						border.color:     root.theme.bar.fill
						border.width:     1

						Rectangle {
							id: brightnessSlider

							anchors.verticalCenter: parent.verticalCenter
							anchors.left:           parent.left
							anchors.leftMargin:     1

							implicitHeight: parent.height - 2
							implicitWidth:  100
							radius:         this.height / 2
							color:          root.theme.bar.fill
						}
					}

					Behavior on opacity { NumberAnimation { duration: 150 } }
				}

				HoverHandler {
					id: brightnessPointer
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
				}

				WheelHandler {
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
					onWheel: function(e) {
						brightnessLevelProcess.running = true
						if (e.angleDelta.y > 0) {
							if (brightnessSlider.width <= 95) {
								Quickshell.execDetached(["brightnessctl", "set", "+5%"])
							} else {
								Quickshell.execDetached(["brightnessctl", "set", "100%"])
							}
						} else {
							if (brightnessSlider.width >= 5) {
								Quickshell.execDetached(["brightnessctl", "set", "5%-"])
							} else {
								Quickshell.execDetached(["brightnessctl", "set", "0%"])
							}
						}
					}
				}
			}

			Rectangle { // Hyprsunset -->
				id: hyprsunsetControl

				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: leftToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

				property bool isActive:   true
				property int  temp:       6000
				property int  tempSlider: 100

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

				Process {
					id:      hyprsunsetTempProcess
					running: true
					command: ["sh", "-c", "hyprctl hyprsunset temperature"]
					stdout:  StdioCollector {
						onStreamFinished: {
							const output = this.text.trim()
							hyprsunsetControl.temp = (output > 6000) ? 6000 : (output < 3500) ? 3500 : output
							hyprsunsetSlider.implicitWidth = (hyprsunsetControl.temp - 3500) / 25
						}
					}
				}

				Timer {
					interval:    1000
					running:     true
					repeat:      true
					onTriggered: {
						hyprsunsetStateProcess.running = true
						hyprsunsetTempProcess.running =  true
					}
				}

				Text {
					id: hyprsunsetIcon

					anchors.verticalCenter: parent.verticalCenter
					anchors.right: parent.right
					anchors.rightMargin: 2

					font { family: root.fontFamily; pixelSize: 13; }

					color: (hyprsunsetControl.isActive)
						? root.theme.sunset.active
						: root.theme.sunset.inactive

					text:  ""
				}

				Rectangle { // Slider
					anchors.verticalCenter: parent.verticalCenter
					anchors.right:          parent.left

					implicitHeight: 20
					implicitWidth:  118
					radius:         this.height / 2
					color:          root.theme.bar.bg
					border.color:   root.theme.bar.border
					border.width:   2
					opacity:        hyprsunsetPointer.hovered ? 1 : 0
					visible:        opacity > 0
					z:              3

					Rectangle {
						anchors.centerIn: parent
						implicitHeight:   6
						implicitWidth:    102
						radius:           this.height / 2
						color:            root.theme.bar.alt
						border.color:     root.theme.bar.fill
						border.width:     1

						Rectangle {
							id: hyprsunsetSlider

							anchors.verticalCenter: parent.verticalCenter
							anchors.left:           parent.left
							anchors.leftMargin:     1

							implicitHeight: parent.height - 2
							implicitWidth:  85
							radius:         this.height / 2
							color:          root.theme.bar.fill
						}
					}

					Behavior on opacity { NumberAnimation { duration: 150 } }
				}

				MouseArea {
					anchors.fill:    parent
					hoverEnabled:    true
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					onClicked:       (m) => m.button === Qt.RightButton
						? (hyprsunsetControl.temp === 6000)
							? Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "3500"])
							: Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "6000"])
						: hyprsunsetControl.toggle()
				}

				HoverHandler {
					id: hyprsunsetPointer
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
				}

				WheelHandler {
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

					onWheel: function(e) {
						hyprsunsetTempProcess.running = true
						if (e.angleDelta.y > 0) {
							if (hyprsunsetSlider.width >= 95) {
								Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "6000"])
							} else {
								Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "+125"])
							}
						} else {
							if (hyprsunsetSlider.width <= 5) {
								Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "3500"])
							} else {
								Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "-125"])
							}
						}
					}
				}
			}
			// <--
		}
	}

	Rectangle { // Clock
		id: clockFace

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          datetime.left
		anchors.rightMargin:    -5

		implicitHeight: parent.height - 1
		implicitWidth:  parent.height + 1
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

				ctx.lineWidth = 1
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

		implicitHeight: parent.height - 1
		implicitWidth:  parent.height + 1
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
				id: hypridleControl

				property bool isActive: true

				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: rightToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

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

				Text {
					anchors.centerIn: parent
					font { family: root.fontFamily; pixelSize: 12; }

					color: (hypridleControl.isActive)
						? root.theme.idle.inactive
						: root.theme.idle.active

					text: (hypridleControl.isActive) ? "󰾪" : ""

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						onClicked:    hypridleControl.toggle()
					}
				}
			}

			Rectangle { // Notifications
				id: notificationControl

				anchors.verticalCenter: parent.verticalCenter

				implicitHeight: rightToggleBar.height - 2
				implicitWidth:  this.height
				color:          root.theme.bar.alt
				radius:         this.height / 2

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
							notificationControl.isActive = (this.text.trim() === "0")
						}
					}
				}

				Process {
					id:      notificationWaitingProcess
					running: true
					command: ["sh", "-c", "dunstctl count waiting"]
					stdout:  StdioCollector {
						onStreamFinished: {
							notificationControl.hasWaiting = (this.text.trim() !== "0")
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

				IconImage {
					anchors.centerIn: parent

					height: 12
					width:  12
					source: (notificationControl.isActive)
						? Quickshell.iconPath('notification-inactive')
						: (notificationControl.hasWaiting)
							? Quickshell.iconPath('notification-active')
							: Quickshell.iconPath('notification-disabled')
				}

				MouseArea {
					anchors.fill:    parent
					hoverEnabled:    true
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					onClicked:       (m) => m.button === Qt.RightButton
						? Quickshell.execDetached(["dunstctl", "close-all"])
						: notificationControl.toggle()
				}

				WheelHandler {
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
					onWheel:         (e) => e.angleDelta.y > 0
						? Quickshell.execDetached(["dunstctl", "history-pop"])
						: Quickshell.execDetached(["dunstctl", "close"])
				}
			}
		}
	} // <--
	// RightMid      -->  Network, Bluetooth
	// <--
	// Right         -->  System Tray, Power Menu
	Rectangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          powerButton.left
		anchors.rightMargin:    -10

		height:           parent.height - 10
		width:            rightBar.width + 16
		topLeftRadius:    this.height / 2
		bottomLeftRadius: this.height / 2
		color:            root.theme.bar.bg
		border.color:     root.theme.bar.border
		border.width:     2

		Row {
			id: rightBar

			anchors.centerIn: parent

			Repeater {
				model: SystemTray.items

				Item {
					id: trayItem

					anchors.verticalCenter: parent.verticalCenter

					implicitHeight: 12
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
	}

	Rectangle { // Power Button
		id: powerButton

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          parent.right

		implicitHeight:    parent.height
		implicitWidth:     parent.height + 4
		topLeftRadius:     this.height / 2
		bottomRightRadius: this.height / 2
		bottomLeftRadius:  this.height / 2
		color:             root.theme.bar.alt
		border.color:      root.theme.bar.border
		border.width:      2
		z:                 2

		IconImage {
			anchors.centerIn: parent

			source: Quickshell.iconPath("battery_plugged")
			height: 24
			width:  24
			smooth: true
		}
	}
	// <--
}

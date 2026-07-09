//@ pragma UseQApplication
//@ pragma IconTheme Papirus-Dark
// pragma ComponentBehavior: Bound
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

	height: 32
	color:  "transparent"

	readonly property string fontFamily: "Maple Mono NF"

	SystemClock {
		id:        sysClock
		precision: SystemClock.Seconds
	}

	// Controls
	// Hyprsunset  -->
	Singleton {
		id: hyprsunsetControl

		property bool isActive: true

		function toggle() {
			if (hyprsunsetControl.isActive) {
				hyprsunsetControl.isActive = false
				Quickshell.execDetached(["sh", "-c", "systemctl --user stop hyprsunset.service"])
			} else {
				hyprsunsetControl.isActive = true
				Quickshell.execDetached(["sh", "-c", "systemctl --user start hyprsunset.service"])
			}
		}

		function getState() {
			hyprsunsetStateProcess.exec()
		}

		Process {
			id:      hyprsunsetStateProcess
			running: true
			command: ["sh", "-c", "systelmctl --user is-active hyprsunset.service"]
			stdout:  StdioCollector {
				onStreamFinished: {
					hyprsunsetControl.isActive = (this.text.trim() === "active")
				}
			}
		}
	}
	// <--

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
		})
	})
	// <--

	// Left        -->  Launcher, Workspaces, Overview
	Rectangle { // Transparent container
		anchors.left:           parent.left
		anchors.verticalCenter: parent.verticalCenter

		height: parent.height
		width:  leftBar.width + 12
		color:  "transparent"

		Rectangle { // Draw the bar
			id: leftBar

			anchors.left:           parent.left
			anchors.verticalCenter: parent.verticalCenter

			height:            parent.height - 10
			width:             workspaces.width + 6
			topRightRadius:    this.height / 2
			bottomRightRadius: this.height / 2
			bottomLeftRadius:  this.height / 2
			color:             root.theme.bar.bg
			border.color:      root.theme.bar.border
			border.width:      2
			opacity:           0.98

			Row {
				id: workspaces

				anchors.verticalCenter: parent.verticalCenter

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

				Rectangle { // Placeholder for Launcher button
					id:     phLauncher
					height: 1
					width:  launcher.width + 4
					color:  "transparent"
				}

				Repeater {
					model: workspaces.hyprWS

					Rectangle {
						anchors.verticalCenter: leftBar.verticalCenter

						height: leftBar.height
						width:  15
						color:  "transparent"

						MouseArea {
							anchors.fill: parent
							onClicked:    Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
						}

						Rectangle {
							property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)

							property bool isActive: ws.focused
							property bool isUrgent: ws.urgent

							anchors.centerIn: parent

							height: {
								if (isActive) { return 12 }
								if (isUrgent) { return 10 }
								if (ws)       { return 8 }
								return 4
							}

							width:  this.height
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

				Rectangle { // Overview Button
					anchors.verticalCenter: parent.verticalCenter

					height: 16
					width:  16
					radius: this.height / 2
					color:  root.theme.bar.border

					IconImage {
						anchors.centerIn: parent

						source: Quickshell.iconPath("preferences-system-windows-move")
						height: 10
						width:  10
						smooth: true
					}
				}
			}
		}

		Rectangle { // Launcher button -->
			id: launcher

			anchors.verticalCenter: parent.verticalCenter
			anchors.left:           parent.left

			height:            parent.height
			width:             parent.height + 4
			topRightRadius:    this.height / 2
			bottomRightRadius: this.height / 2
			bottomLeftRadius:  this.height / 2
			color:             root.theme.bar.alt
			border.color:      root.theme.bar.border
			border.width:      2

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
		} // <--

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

	} // <--
	// LeftMid     -->  Volume, Media Controls
	// <--
	// Center      -->  Hyprsunset, Brightness, Clock, Time, Date, Calendar, Hypridle, Notifications
	Rectangle {
		anchors.centerIn: parent

		height:            parent.height - 6
		width:             centerBar.width + 72
		topLeftRadius:     this.height / 2
		topRightRadius:    this.height / 2
		bottomLeftRadius:  this.height / 2
		bottomRightRadius: this.height / 2
		color:             root.theme.bar.bg
		border.color:      root.theme.bar.border
		border.width:      2
		opacity:           0.98

		Row {
			anchors.centerIn: parent

			Text {
				id: sunsetText

				anchors.verticalCenter: parent.verticalCenter
				anchors.right:          centerSpacer.left

				font { family: root.fontFamily; pixelSize: 16; }

				color: {
					if (hyprsunsetControl.isActive) {
						return root.theme.sunset.active
					}
					return root.theme.sunset.inactive
				}
				text:  ""

				MouseArea {
					anchors.fill: parent
					hoverEnabled:    true
					onClicked: hyprsunsetControl.toggle()
				}
			}

			Rectangle {
				id: centerSpacer

				anchors.centerIn: parent

				height: 2
				width:  centerBar.width + 16
				color:  "transparent"
			}

			IconImage {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left:           centerSpacer.right

				source: Quickshell.iconPath('notification-inactive')
				height: 16
				width:  16
			}
		}
	}

	Rectangle {
		anchors.centerIn: parent

		height:            parent.height - 2
		width:             centerBar.width + 4
		topLeftRadius:     this.height / 2
		topRightRadius:    this.height / 2
		bottomLeftRadius:  this.height / 2
		bottomRightRadius: this.height / 2
		color:             root.theme.bar.bg
		border.color:      root.theme.bar.border
		border.width:      2
		opacity:           0.98

		Row {
			id: centerBar

			anchors.centerIn: parent

			Rectangle { // Clock    -->
				id: clockFace

				anchors.verticalCenter: parent.verticalCenter

				height:       26
				width:        26
				radius:       13
				color:        root.theme.clock.bg
				border.color: root.theme.clock.border
				border.width: 1

				Rectangle { // Minute Hand
					anchors.bottom: clockFace.verticalCenter
					anchors.horizontalCenter: clockFace.horizontalCenter

					height:          12
					width:           1
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

					height:          7
					width:           2
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
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width:  10
				color:  "transparent"
			}
			// <--
			Text      { // Time     -->
				id: time

				anchors.verticalCenter: parent.verticalCenter

				font { family: root.fontFamily; pixelSize: 12; }

				color: root.theme.clock.text
				text:  Qt.formatDateTime( sysClock.date, "HH:mm" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width:  16
				color:  "transparent"
			}
			// <--
			Text      { // Date     -->
				id: date

				anchors.verticalCenter: parent.verticalCenter

				font { family: root.fontFamily; pixelSize: 12; }

				color: root.theme.cal.text
				text:  Qt.formatDateTime( sysClock.date, "ddd, MMM dd" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width:  10
				color:  "transparent"
			}
			// <--
			Rectangle { // Calendar -->
				anchors.verticalCenter: parent.verticalCenter

				height:       26
				width:        26
				radius:       13
				color:        root.theme.cal.bg
				border.color: root.theme.cal.border
				border.width: 1

				IconImage {
					anchors.centerIn: parent

					height: 12
					width:  12
					source: Quickshell.iconPath('calendar')
				}
			}
			// <--
		}
	} // <--
	// RightMid    -->  Network, Bluetooth
	// <--
	// Right       -->  System Tray, Power Menu
	Rectangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          parent.right

		height:           parent.height - 8
		width:            rightBar.width + 8
		topLeftRadius:    this.height / 2
		bottomLeftRadius: this.height / 2
		color:            root.theme.bar.bg
		border.color:     root.theme.bar.border
		border.width:     2
		opacity:          0.98

		Row {
			id: rightBar

			anchors.centerIn: parent

			Repeater {
				model: SystemTray.items

				Item {
					id: trayItem

					anchors.verticalCenter: parent.verticalCenter

					height: 16
					width:  20

					required property var modelData

					IconImage {
						anchors.verticalCenter: parent.verticalCenter
						anchors.left:           parent.left

						height: 16
						width:  this.height
						source: trayItem.modelData.icon
						smooth: true
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

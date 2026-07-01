//@ pragma UseQApplication
//@ pragma IconTheme Papirus
// vim:fdm=marker:fdl=0:foldmarker=-->,<--

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

PanelWindow {
	id: root

	anchors {
		top: true
		left: true
		right: true
	}
	color: "transparent"

	implicitHeight: 32

	SystemClock {
		id: sysClock
		precision: SystemClock.Seconds
	}

	property string fontFamily: "Maple Mono NF"

	// Colors -->
	// Bar
	property string colorBar:         "#303446"
	property string colorBarBorder:   "#232634"
	property string colorBarSecond:   "#414559"
	property string colorBarThird:    "#a6d189"
	// Worspaces
	property string colorWSAc:        "#81c8be"
	property string colorWSIn:        "#8caaee"
	property string colorWSEm:        "#414559"
	property string colorWSBorder:    "#292c3c"
	// Datetime
	property string colorClock:       "#292c3c"
	property string colorClockHands:  "#8caaee"
	property string colorClockBorder: "#ca9ee6"
	property string colorClockText:   "#c6d0f5"
	property string colorCal:         "#292c3c"
	property string colorCalText:     "#c6d0f5"
	property string colorCalBorder:   "#ef9f76"
	// <--

	// Left -->
	// Application Launcher (distro icon) (Large)
	// Workspace Switcher
	// Overview Launcher
	// Rectangle transparent container
	// Row
	// Rectangle large button
	// Rectangle workspaces repeater
	// Overview button
	Rectangle {
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height - 2
		width: leftBar.width + 12
		color: "transparent"

		Rectangle {
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
			height: parent.height
			width: leftBar.width + 12
			topRightRadius: this.height / 2
			bottomRightRadius: this.height / 2
			color: colorBar
			border.color: colorBarBorder
			border.width: 2
			opacity: 0.98
		}

		Row {
			id: leftBar
			anchors.centerIn: parent

			IconImage {
				anchors.verticalCenter: parent.verticalCenter
				source: Quickshell.iconPath('distributor-logo-nixos')
				height: 20
				width: 20
			}

			Rectangle {
				width: 10
				height: 1
				color: "transparent"
			}

			Repeater {
				model: 10

				Rectangle {
					anchors.verticalCenter: root.verticalCenter
					height: 20
					width: 16
					color: "transparent"

					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
					}

					Rectangle {
						property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
						property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

						anchors.centerIn: parent
						height: isActive ? 12 : (ws ? 8 : 4)
						width: isActive ? 12 : (ws ? 8 : 4)
						color: isActive ? colorWSAc : (ws ? colorWSIn : colorWSEm)
						radius: this.width / 2

					}
				}
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
		}
	} // <--

	// LeftMid -->
	// Media controls
	// Volume
	// <--

	// Center -->
	// hyprsunset indicator (active, inactive, disabled)
	// Alarm Launcher
	// clock face (Large)
	// date time text
	// Calendar (Large)
	// Notification (active, inactive, disabled)
	// hypridle indicator (active, disabled)
	Rectangle {
		anchors.centerIn: parent
		height: parent.height - 6
		width: centerBar.width + 72
		topLeftRadius: this.height / 2
		topRightRadius: this.height / 2
		bottomLeftRadius: this.height / 2
		bottomRightRadius: this.height / 2
		color: colorBarSecond
		border.color: colorBarBorder
		border.width: 2
		opacity: 0.98

		Row {
			anchors.centerIn: parent
			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: centerSpacer.left
				color: "#ef9f76"
				font { family: fontFamily; pixelSize: 16; }
				text: ""
			}
			Rectangle {
				id: centerSpacer
				anchors.centerIn: parent
				height: 2
				width: centerBar.width + 16
				color: "transparent"
			}
			IconImage {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: centerSpacer.right
				source: Quickshell.iconPath('notification-inactive')
				height: 16
				width: 16
			}
		}
	}

	Rectangle {
		anchors.centerIn: parent
		height: parent.height - 2
		width: centerBar.width + 4
		topLeftRadius: this.height / 2
		topRightRadius: this.height / 2
		bottomLeftRadius: this.height / 2
		bottomRightRadius: this.height / 2
		color: colorBar
		border.color: colorBarBorder
		border.width: 2
		opacity: 0.98

		Row {
			id: centerBar
			anchors.centerIn: parent

			Rectangle { // Clock    -->
				anchors.verticalCenter: parent.verticalCenter
				id: clockFace
				height: 26
				width: 26
				radius: 13
				color: colorClock
				border.color: colorClockBorder
				border.width: 1

				Rectangle { // Minute Hand
					anchors.bottom: clockFace.verticalCenter
					anchors.horizontalCenter: clockFace.horizontalCenter
					height: 12
					width: 1
					color: colorClockHands
					antialiasing: true
					transformOrigin: Item.Bottom
					rotation: {
						const d = sysClock.date;
						return d.getMinutes() * 6;
					}
					Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
				}

				Rectangle { // Hour Hand
					anchors.bottom: clockFace.verticalCenter
					anchors.horizontalCenter: clockFace.horizontalCenter
					height: 7
					width: 2
					color: colorClockHands
					antialiasing: true
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
				width: 10
				color: "transparent"
			}
			// <--
			Text      { // Time     -->
				id: time
				anchors.verticalCenter: parent.verticalCenter
				color: colorClockText
				font { family: fontFamily; pixelSize: 12; }
				text: Qt.formatDateTime( sysClock.date, "HH:mm" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width: 16
				color: "transparent"
			}
			// <--
			Text      { // Date     -->
				id: date
				anchors.verticalCenter: parent.verticalCenter
				color: colorCalText
				font { family: fontFamily; pixelSize: 12; }
				text: Qt.formatDateTime( sysClock.date, "ddd, MMM dd" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width: 10
				color: "transparent"
			}
			// <--
			Rectangle { // Calendar -->
				anchors.verticalCenter: parent.verticalCenter
				height: 26
				width: 26
				radius: 13
				color: colorCal
				border.color: colorCalBorder
				border.width: 1

				IconImage {
					anchors.centerIn: parent
					source: Quickshell.iconPath('calendar')
					height: 13
					width: 13
				}
			}
			// <--
		}
	} // <--

	// RightMid -->
	// Network (wired/wireless)
	// Tailscale
	// Bluetooth
	// <--

	// Right -->
	// System Tray
	// Power/lock menu launcher (Large)
	Rectangle {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height - 8
		width: rightBar.width + parent.height / 2
		topLeftRadius: this.height / 2
		bottomLeftRadius: this.height / 2
		color: colorBar
		border.color: colorBarBorder
		border.width: 2
		opacity: 0.98

		Row {
			id: rightBar
			anchors.centerIn: parent
			spacing: 8

			Repeater {
				model: SystemTray.items

				Item {
					id: trayItem
					anchors.verticalCenter: parent.verticalCenter
					required property var modelData
					height: 16
					width: 16

					IconImage {
						anchors.fill: parent
						source: trayItem.modelData.icon
						smooth: true
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						acceptedButtons: Qt.LeftButton | Qt.RightButton
						onClicked: (m) => m.button === Qt.RightButton
							? modelData.display(root, root.width - 24, rightBar.height + 12)
							: modelData.activate()
					}
				}

			}
		}
	} // <--

}

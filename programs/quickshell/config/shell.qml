//@ pragma UseQApplication
// vim:fdm=marker:fdl=0:foldmarker=-->,<--
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick

PanelWindow {
	id: root

	anchors {
		top: true
		left: true
		right: true
	}
	color: "transparent"

	implicitHeight: 24

	SystemClock {
		id: sysClock
		precision: SystemClock.Seconds
	}

	property string fontFamily: "Maple Mono NF"

	// Left -->
	Rectangle {
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height - 4
		width: leftBar.width + 8
		topRightRadius: 12
		bottomRightRadius: 12
		color: "#303446"
		border.color: "#292c3c"
		border.width: 2
		opacity: 0.98

		Row {
			id: leftBar
			anchors.centerIn: parent
			spacing: 4

			Repeater {
				model: 10

				Text {
					property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
					property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

					font { family: root.fontFamily; pixelSize: 16; bold: true }
					color: isActive ? "#81c8be" : (ws ? "#8caaee" : "#414559")

					text: isActive ? '' : (ws ? '' : '')

					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + "})")
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

	// Center -->
	Rectangle {
		anchors.centerIn: parent
		height: parent.height - 4
		width: centerBar.width + 4
		topLeftRadius: 12
		topRightRadius: 12
		bottomLeftRadius: 12
		bottomRightRadius: 12
		color: "#303446"
		border.color: "#292c3c"
		border.width: 2
		opacity: 0.98

		Row {
			id: centerBar
			anchors.centerIn: parent

			Rectangle { // Clock    -->
				anchors.verticalCenter: parent.verticalCenter
				id: clockFace
				height: 16
				width: 16
				radius: 8
				color: "#414559"
				border.color: "#ca9ee6"
				border.width: 1

				Rectangle { // Minute Hand
					anchors.bottom: clockFace.verticalCenter
					anchors.horizontalCenter: clockFace.horizontalCenter
					height: 7
					width: 1
					color: "#ca9ee6"
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
					height: 4
					width: 1
					color: "#ca9ee6"
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
				width: 8
				color: "transparent"
			}
			// <--
			Text      { // Time     -->
				id: time
				anchors.verticalCenter: parent.verticalCenter
				color: "#ca9ee6"
				font { family: root.fontFamily; pixelSize: 12; }
				text: Qt.formatDateTime( sysClock.date, "HH:mm" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width: 24
				color: "transparent"
			}
			// <--
			Text      { // Date     -->
				id: date
				anchors.verticalCenter: parent.verticalCenter
				color: "#ef9f76"
				font { family: root.fontFamily; pixelSize: 12; }
				text: Qt.formatDateTime( sysClock.date, "ddd, MMM dd" )
			}
			// <--
			Rectangle { // Spacer   -->
				height: parent.height
				width: 8
				color: "transparent"
			}
			// <--
			Rectangle { // Calendar -->
				anchors.verticalCenter: parent.verticalCenter
				height: 16
				width: 16
				radius: 8
				color: "#414559"
				border.color: "#ef9f76"
				border.width: 1

				Text {
					anchors.centerIn: parent
					font { family: root.fontFamily; pixelSize: 8; bold: true }
					color: "#ef9f76"
					text: ""
				}
			}
			// <--
		}
	} // <--

	// Right -->
	Rectangle {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height - 4
		width: rightBar.width + 6
		topLeftRadius: 12
		bottomLeftRadius: 12
		color: "#303446"
		border.color: "#292c3c"
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
					required property var modelData
					implicitHeight: 14
					implicitWidth: 14

					Image {
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

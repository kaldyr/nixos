//@ pragma UseQApplication
// vim:fdm=marker:fdl=0:foldmarker=-->,<--
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PanelWindow {

	id: root

	anchors {
		top: true
		left: true
		right: true
	}
	color: "transparent"

	implicitHeight: 24

	property string fontFamily: "Maple Mono NF"

	// Left -->
	Rectangle {
		anchors.left: parent.left
		height: parent.height
		width: leftBar.width + 24
		bottomRightRadius: 16
		color: "#292c3c"
		opacity: 0.95

		Row {
			anchors.centerIn: parent
			id: leftBar
			spacing: 8
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
		}
	} // <--

	// Center -->
	Rectangle {
		anchors.centerIn: parent
		height: parent.height
		width: centerBar.width + 36
		bottomLeftRadius: 16
		bottomRightRadius: 16
		color: "#292c3c"
		opacity: 0.95

		Row {
			id: centerBar
			anchors.centerIn: parent
			Text {
				id: clock
				color: "#85c1dc"

				property string fmt: "    hh:mm   ·   ddd, MMM dd    "

				font { family: root.fontFamily; pixelSize: 12; bold: true }

				text: Qt.formatDateTime(new Date(), clock.fmt)

				Timer {
					interval: 1000
					running: true
					repeat: true
					onTriggered: clock.text = Qt.formatDateTime(new Date(), clock.fmt)
				}
			}
		}
	} // <--

	// Right -->
	Rectangle {
		anchors.right: parent.right
		height: parent.height
		width: rightBar.width + 24
		bottomLeftRadius: 16
		color: "#292c3c"
		opacity: 0.95

		Row {
			id: rightBar
			anchors.centerIn: parent
			spacing: 8

			Repeater {
				model: SystemTray.items

				Item {
					id: trayItem
					required property var modelData
					implicitHeight: 16
					implicitWidth: 16

					Image {
						anchors.fill: parent
						source: trayItem.modelData.icon
						sourceSize: Qt.size(16, 16)
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

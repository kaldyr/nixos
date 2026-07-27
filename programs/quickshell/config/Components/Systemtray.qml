import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Rectangle {
	height:           parent.height - 10
	width:            rightBar.width + 16
	topLeftRadius:    this.height / 2
	bottomLeftRadius: this.height / 2
	color:            Theme.bar.bg
	border.color:     Theme.bar.border
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

import Quickshell.Hyprland
import QtQuick

Rectangle {
	implicitHeight:    parent.height - 10
	implicitWidth:     workspaces.width + 16
	topRightRadius:    this.height / 2
	bottomRightRadius: this.height / 2
	color:             Theme.bar.bg
	border.color:      Theme.bar.border
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

				required property int index
				anchors.verticalCenter: parent.verticalCenter

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
						if (isUrgent) { return Theme.ws.urgent }
						if (isActive) { return Theme.ws.active }
						if (ws)       { return Theme.ws.inactive }
						return Theme.ws.empty
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

				font { family: Theme.font; pixelSize: 18; }

				color: Theme.ws.overview
				text:  "󱒉"

				// MouseArea {
				// 	anchors.fill: parent
				// 	hoverEnabled: true
				// 	onClicked:
				// }
			}
		}
	}
}

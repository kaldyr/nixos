import Quickshell
import QtQuick

Rectangle {
	implicitHeight: parent.height - 10
	implicitWidth:  180
	color:          Theme.bar.bg
	border.color:   Theme.bar.border
	border.width:   2

	Row {
		anchors.centerIn: parent

		Text { // Time
			id: time
			anchors.verticalCenter: parent.verticalCenter

			font { family: Theme.font; pixelSize: 12; }

			color: Theme.clock.text
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

			font { family: Theme.font; pixelSize: 12; }

			color: Theme.cal.text
			text:  Qt.formatDateTime( sysClock.date, "ddd, MMM dd" )
		}
	}
}

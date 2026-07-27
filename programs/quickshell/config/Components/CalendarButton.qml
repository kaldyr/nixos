import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
	id: calendar

	implicitHeight: parent.height - 1
	implicitWidth:  parent.height + 1
	radius:         this.height / 2
	color:          Theme.bar.alt
	border.color:   Theme.bar.border
	border.width:   2
	z:              2

	IconImage {
		anchors.centerIn: parent

		height: 15
		width:  15
		source: Quickshell.iconPath('calendar')
	}
}

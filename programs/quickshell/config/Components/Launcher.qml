import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
	id: launcher

	implicitHeight:    parent.height
	implicitWidth:     parent.height + 4
	topRightRadius:    this.height / 2
	bottomRightRadius: this.height / 2
	bottomLeftRadius:  this.height / 2
	color:             Theme.bar.alt
	border.color:      Theme.bar.border
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
		onClicked:    Quickshell.execDetached(["fuzzel"])
	}
}

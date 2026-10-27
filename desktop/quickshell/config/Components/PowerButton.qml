import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
    implicitHeight: parent.height
    implicitWidth: parent.height + 4
    topLeftRadius: this.height / 2
    bottomRightRadius: this.height / 2
    bottomLeftRadius: this.height / 2
    color: Theme.colors.mantle
    border.color: Theme.colors.crust
    border.width: 2
    z: 2

    IconImage {
        anchors.centerIn: parent

        source: Quickshell.iconPath("battery_plugged")
        height: 24
        width: 24
        smooth: true
    }
}

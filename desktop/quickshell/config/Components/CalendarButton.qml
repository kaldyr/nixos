import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
    id: calendar

    implicitHeight: parent.height - 1
    implicitWidth: parent.height + 1
    radius: this.height / 2
    color: Theme.colors.mantle
    border.color: Theme.colors.crust
    border.width: 2
    z: 2

    IconImage {
        anchors.centerIn: parent

        height: 15
        width: 15
        source: Quickshell.iconPath('calendar')

        MouseArea {
            anchors.fill: parent
            onClicked: Settings.toggleTheme()
        }
    }
}

import Quickshell
import QtQuick

Rectangle {
    implicitHeight: parent.height - 10
    implicitWidth: 180
    color: Theme.colors.base
    border.color: Theme.colors.crust
    border.width: 2

    Row {
        anchors.centerIn: parent

        Text { // Time
            id: time
            anchors.verticalCenter: parent.verticalCenter

            font {
                family: Settings.appearance.font
                pixelSize: Settings.appearance.fontSize
            }

            color: Theme.colors.text
            text: Qt.formatDateTime(sysClock.date, "h:mm ap")
        }

        Rectangle { // Spacer
            height: parent.height
            implicitWidth: 22
            color: "transparent"
        }

        Text { // Date
            id: date

            anchors.verticalCenter: parent.verticalCenter

            font {
                family: Settings.appearance.font
                pixelSize: Settings.appearance.fontSize
            }

            color: Theme.colors.text
            text: Qt.formatDateTime(sysClock.date, "ddd, MMM dd")
        }
    }
}

import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick

Rectangle {
	id: notificationControl

	anchors.verticalCenter: parent.verticalCenter

	implicitHeight: parent.height - 4
	implicitWidth:  this.height
	color:          Theme.bar.alt
	radius:         this.height / 2

	property bool isActive:   true
	property bool hasWaiting: false

	function toggle() {
		if (this.isActive) {
			this.isActive = false
			Quickshell.execDetached(["sh", "-c", "dunstctl set-paused true"])
		} else {
			this.isActive = true
			Quickshell.execDetached(["sh", "-c", "dunstctl set-paused false"])
		}
	}

	Process {
		id:      notificationStateProcess
		running: true
		command: ["sh", "-c", "dunstctl get-pause-level"]
		stdout:  StdioCollector {
			onStreamFinished: {
				notificationControl.isActive = (this.text.trim() === "0")
			}
		}
	}

	Process {
		id:      notificationWaitingProcess
		running: true
		command: ["sh", "-c", "dunstctl count waiting"]
		stdout:  StdioCollector {
			onStreamFinished: {
				notificationControl.hasWaiting = (this.text.trim() !== "0")
			}
		}
	}

	Timer {
		interval:    1000
		running:     true
		repeat:      true
		onTriggered: {
			notificationStateProcess.running = true
			notificationWaitingProcess.running = true
		}
	}

	IconImage {
		anchors.centerIn: parent

		implicitHeight: 12
		implicitWidth:  12

		source: (notificationControl.isActive)
			? Quickshell.iconPath('notification-inactive')
			: (notificationControl.hasWaiting)
				? Quickshell.iconPath('notification-active')
				: Quickshell.iconPath('notification-disabled')
	}

	MouseArea {
		anchors.fill:    parent
		hoverEnabled:    true
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked:       (m) => m.button === Qt.RightButton
			? Quickshell.execDetached(["dunstctl", "close-all"])
			: notificationControl.toggle()
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
		onWheel:         (e) => e.angleDelta.y > 0
			? Quickshell.execDetached(["dunstctl", "history-pop"])
			: Quickshell.execDetached(["dunstctl", "close"])
	}
}

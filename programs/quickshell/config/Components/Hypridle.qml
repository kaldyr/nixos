import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
	id: hypridleControl

	property bool isActive: true

	anchors.verticalCenter: parent.verticalCenter

	implicitHeight: parent.height - 4
	implicitWidth:  this.height
	color:          Theme.bar.alt
	radius:         this.height / 2

	function toggle() {
		if (this.isActive) {
			this.isActive = false
			Quickshell.execDetached(["sh", "-c", "systemctl --user stop hypridle.service"])
		} else {
			this.isActive = true
			Quickshell.execDetached(["sh", "-c", "systemctl --user start hypridle.service"])
		}
	}

	Process {
		id:      hypridleStateProcess
		running: true
		command: ["sh", "-c", "systemctl --user is-active hypridle.service"]
		stdout:  StdioCollector {
			onStreamFinished: {
				hypridleControl.isActive = (this.text.trim() === "active")
			}
		}
	}

	Timer {
		interval:    1000
		running:     true
		repeat:      true
		onTriggered: hypridleStateProcess.running = true
	}

	Text {
		anchors.centerIn: parent
		font { family: Theme.font; pixelSize: 12; }

		color: (hypridleControl.isActive)
			? Theme.idle.inactive
			: Theme.idle.active

		text: (hypridleControl.isActive) ? "󰾪" : ""

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked:    hypridleControl.toggle()
		}
	}
}

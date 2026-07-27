import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
	id: hyprsunsetControl
	anchors.verticalCenter: parent.verticalCenter

	implicitHeight: parent.height - 6
	implicitWidth:  this.height
	color:          Theme.bar.alt
	radius:         this.height / 2

	property bool isActive:      true
	property int  temp:          6000
	property bool sliderVisible: false

	function toggle() {
		if (this.isActive) {
			this.isActive = false
			Quickshell.execDetached(["sh", "-c", "systemctl --user stop hyprsunset.service"])
		} else {
			this.isActive = true
			Quickshell.execDetached(["sh", "-c", "systemctl --user start hyprsunset.service"])
		}
	}

	Process {
		id:      hyprsunsetStateProcess
		running: true
		command: ["sh", "-c", "systemctl --user is-active hyprsunset.service"]
		stdout:  StdioCollector {
			onStreamFinished: {
				hyprsunsetControl.isActive = (this.text.trim() === "active")
			}
		}
	}

	Process {
		id:      hyprsunsetTempProcess
		running: true
		command: ["sh", "-c", "hyprctl hyprsunset temperature"]
		stdout:  StdioCollector {
			onStreamFinished: {
				const output = this.text.trim()
				hyprsunsetControl.temp = (output > 6000) ? 6000 : (output < 3500) ? 3500 : output
				hyprsunsetSlider.implicitWidth = (hyprsunsetControl.temp - 3500) / 25
			}
		}
	}

	Timer {
		interval:    1000
		running:     true
		repeat:      true
		onTriggered: {
			hyprsunsetStateProcess.running = true
			hyprsunsetTempProcess.running =  true
		}
	}

	Timer {
		id:          hyprsunsetSliderTimeout
		interval:    1000
		repeat:      false
		onTriggered: {
			hyprsunsetControl.sliderVisible = false
			root.sliderLocked               = false
		}
	}

	Text {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 1

		font { family: Theme.font; pixelSize: 11; }

		color: (hyprsunsetControl.isActive)
			? Theme.sunset.active
			: Theme.sunset.inactive

		text:  ""
	}

	Rectangle { // Slider
		anchors.verticalCenter: hyprsunsetControl.verticalCenter
		anchors.right:          (sliderDirection === "left")
                              ? hyprsunsetControl.left
										: undefined
		anchors.left:           (sliderDirection === "right")
                              ? hyprsunsetControl.right
										: undefined

		implicitHeight: 20
		implicitWidth:  118
		radius:         this.height / 2
		color:          Theme.bar.bg
		border.color:   Theme.bar.border
		border.width:   2
		opacity:        hyprsunsetControl.sliderVisible ? 1 : 0
		visible:        opacity > 0
		z:              3

		Rectangle {
			anchors.centerIn: parent
			implicitHeight:   6
			implicitWidth:    102
			radius:           this.height / 2
			color:            Theme.bar.alt
			border.color:     Theme.bar.fill
			border.width:     1

			Rectangle {
				id: hyprsunsetSlider

				anchors.verticalCenter: parent.verticalCenter
				anchors.left:           parent.left
				anchors.leftMargin:     1

				implicitHeight: parent.height - 2
				implicitWidth:  85
				radius:         this.height / 2
				color:          Theme.bar.fill
			}

			MouseArea {
				anchors.fill:      parent
				hoverEnabled:      true
				acceptedButtons:   Qt.LeftButton | Qt.RightButton
				onEntered:         hyprsunsetSliderTimeout.stop()
				onPositionChanged: hyprsunsetSliderTimeout.stop()
				onExited:          hyprsunsetSliderTimeout.restart()
				onClicked:         (m) => {
					const level = Math.round(3500 + (m.x * 25))
					Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", level.toString()])
					hyprsunsetTempProcess.running = true
				}
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

			onWheel: function(e) {
				hyprsunsetTempProcess.running = true
				if (e.angleDelta.y > 0) {
					if (hyprsunsetSlider.width >= 95) {
						Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "6000"])
					} else {
						Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "+125"])
					}
				} else if (e.angleDelta.y < 0) {
					if (hyprsunsetSlider.width <= 5) {
						Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "3500"])
					} else {
						Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "-125"])
					}
				}
			}
		}

		Behavior on opacity { NumberAnimation { duration: 150 } }
	}

	MouseArea {
		anchors.fill:      parent
		hoverEnabled:      true
		acceptedButtons:   Qt.LeftButton | Qt.RightButton
		onClicked:         (m) => m.button === Qt.RightButton
			? (hyprsunsetControl.temp === 6000)
				? Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "3500"])
				: Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "6000"])
			: hyprsunsetControl.toggle()
		onEntered:         {
			if (!root.sliderLocked) {
				root.sliderLocked               = true
				hyprsunsetControl.sliderVisible = true
				hyprsunsetSliderTimeout.stop()
			}
		}
		onPositionChanged: {
			if (!root.sliderLocked) {
				root.sliderLocked               = true
				hyprsunsetControl.sliderVisible = true
			}
			hyprsunsetSliderTimeout.stop()
		}
		onExited:          hyprsunsetSliderTimeout.restart()
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
		onWheel: function(e) {
			hyprsunsetTempProcess.running = true
			if (e.angleDelta.y > 0) {
				if (hyprsunsetSlider.width >= 95) {
					Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "6000"])
				} else {
					Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "+125"])
				}
			} else if (e.angleDelta.y < 0) {
				if (hyprsunsetSlider.width <= 5) {
					Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "3500"])
				} else {
					Quickshell.execDetached(["hyprctl", "hyprsunset", "temperature", "-125"])
				}
			}
		}
	}
}

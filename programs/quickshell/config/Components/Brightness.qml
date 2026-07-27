import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick

Rectangle {
	id: brightnessControl

	anchors.verticalCenter: parent.verticalCenter

	implicitHeight: parent.height - 6
	implicitWidth:  this.height
	color:          Theme.bar.alt
	radius:         this.height / 2

	property int  brightness:    100
	property bool sliderVisible: false

	Process {
		id:      brightnessLevelProcess
		running: true
		command: ["sh", "-c", "brightnessctl -m | awk -F, '{print $2 \",\" $4}' | tr -d '%'"]
		stdout:  StdioCollector {
			onStreamFinished: {
				const output = this.text.trim().split(',')
				if (output.length !== 2) return;

				const level  = parseInt(output[1], 10)

				brightnessTimer.interval = (output[0] === "backlight") ? 1000 : 10000
				brightnessControl.brightness = (output[0] === "backlight") ? level : 100
				brightnessSlider.width = brightnessControl.brightness
			}
		}
	}

	Timer {
		id:          brightnessTimer
		interval:    1000
		running:     true
		repeat:      true
		onTriggered: {
			brightnessLevelProcess.running =  true
		}
	}

	Timer {
		id:          brightnessSliderTimeout
		interval:    1000
		repeat:      false
		onTriggered: {
			brightnessControl.sliderVisible = false
			root.sliderLocked               = false
		}
	}

	IconImage {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          parent.right
		anchors.rightMargin:    2

		height: 12
		width:  12
		source: Quickshell.iconPath('brightnesssettings')
	}

	Rectangle { // Slider
		anchors.verticalCenter: brightnessControl.verticalCenter
		anchors.right:          (sliderDirection === "left")
                              ? brightnessControl.left
										: undefined
		anchors.left:           (sliderDirection === "right")
                              ? brightnessControl.right
										: undefined

		implicitHeight: 20
		implicitWidth:  118
		radius:         this.height / 2
		color:          Theme.bar.bg
		border.color:   Theme.bar.border
		border.width:   2
		opacity:        brightnessControl.sliderVisible ? 1 : 0
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
				id: brightnessSlider

				anchors.verticalCenter: parent.verticalCenter
				anchors.left:           parent.left
				anchors.rightMargin:    1

				implicitHeight: parent.height - 2
				implicitWidth:  100
				radius:         this.height / 2
				color:          Theme.bar.fill
			}

			MouseArea {
				anchors.fill:      parent
				hoverEnabled:      true
				acceptedButtons:   Qt.LeftButton | Qt.RightButton
				onEntered:         brightnessSliderTimeout.stop()
				onPositionChanged: brightnessSliderTimeout.stop()
				onExited:          brightnessSliderTimeout.restart()
				onClicked:         (m) => {
					Quickshell.execDetached(["brightnessctl", "set", m.x.toString() + "%"])
					brightnessLevelProcess.running = true
				}
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
			onWheel: function(e) {
				brightnessLevelProcess.running = true
				if (e.angleDelta.y > 0) {
					if (brightnessControl.brightness >= 95) {
						Quickshell.execDetached(["brightnessctl", "set", "100%"])
					} else {
						Quickshell.execDetached(["brightnessctl", "set", "+5%"])
					}
				} else if (e.angleDelta.y < 0) {
					if (brightnessControl.brightness <= 6) {
						Quickshell.execDetached(["brightnessctl", "set", "1%"])
					} else {
						Quickshell.execDetached(["brightnessctl", "set", "5%-"])
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
		onEntered:         {
			if (!root.sliderLocked) {
				root.sliderLocked               = true
				brightnessControl.sliderVisible = true
				brightnessSliderTimeout.stop()
			}
		}
		onPositionChanged: {
			if (!root.sliderLocked) {
				root.sliderLocked               = true
				brightnessControl.sliderVisible = true
			}
			brightnessSliderTimeout.stop()
		}
		onExited:          brightnessSliderTimeout.restart()
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
		onWheel: function(e) {
			brightnessLevelProcess.running = true
			if (e.angleDelta.y > 0) {
				if (brightnessControl.brightness >= 95) {
					Quickshell.execDetached(["brightnessctl", "set", "100%"])
				} else {
					Quickshell.execDetached(["brightnessctl", "set", "+5%"])
				}
			} else if (e.angleDelta.y < 0) {
				if (brightnessControl.brightness <= 6) {
					Quickshell.execDetached(["brightnessctl", "set", "1%"])
				} else {
					Quickshell.execDetached(["brightnessctl", "set", "5%-"])
				}
			}
		}
	}
}

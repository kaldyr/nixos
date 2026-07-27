import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Rectangle {
	id: sinkControl

	property bool sliderVisible: false
	property var sink: Pipewire.defaultAudioSink

	implicitHeight:    parent.height - 8
	implicitWidth:     parent.height - 7
	radius:            this.height / 2
	color:             Theme.bar.alt
	border.color:      Theme.bar.border
	border.width:      2
	z:                 2

	PwObjectTracker { objects: [sinkControl.sink] }

	Connections {
		target: sinkControl.sink?.audio ?? null
		enabled: target !== null
		function onVolumeChanged() {
			sinkControl.sliderVisible = true
			sinkSliderTimeout.restart()
		}
	}

	Timer {
		id:          sinkSliderTimeout
		interval:    1000
		repeat:      false
		onTriggered: sinkControl.sliderVisible = false
	}

	Text {
		id: sinkIcon

		anchors.centerIn: parent

		property var  sink:        sinkControl.sink
		property bool isBluetooth: sink && sink.name.includes("bluez")
		property bool isHDMI:      sink && sink.name.includes("hdmi")
		property bool isHeadphone: sink && sink.name.includes("headphone")
		property bool isSpeaker:   sink && sink.name.includes("analog")

		font { family: Theme.font; pixelSize: 12; }

		color: sinkControl.sink.audio.muted ? Theme.ltgrey : Theme.white
		text:  (isBluetooth) ? "󰂰"
			  : (isHDMI)      ? "󰽟"
			  : (isHeadphone) ? ""
		     : (isSpeaker)   ? "󰓃"
			  : ""
	}

	Rectangle {
		anchors.verticalCenter: sinkControl.verticalCenter
		anchors.right:          sinkControl.left
		anchors.rightMargin:    -8

		implicitHeight: 20
		implicitWidth:  118
		radius:         this.height / 2
		color:          Theme.bar.bg
		border.color:   Theme.bar.border
		border.width:   2
		opacity:        sinkControl.sliderVisible ? 1 : 0
		visible:        opacity > 0
		z:              1

		Rectangle {
			anchors.centerIn: parent
			implicitHeight:   6
			implicitWidth:    102
			radius:           this.height / 2
			color:            Theme.bar.alt
			border.color:     Theme.bar.fill
			border.width:     1

			Rectangle {
				id: sinkSlider

				anchors.verticalCenter: parent.verticalCenter
				anchors.left:           parent.left
				anchors.leftMargin:     1

				implicitHeight: parent.height - 2
				implicitWidth:  sinkControl.sink.audio.muted ? 0 : (sinkControl.sink?.audio.volume ?? 0) * 100
				radius:         this.height / 2
				color:          Theme.bar.fill
			}

			MouseArea {
				anchors.fill:      parent
				hoverEnabled:      true
				acceptedButtons:   Qt.LeftButton | Qt.RightButton
				onEntered:         sinkSliderTimeout.stop()
				onPositionChanged: sinkSliderTimeout.stop()
				onExited:          sinkSliderTimeout.restart()
				onClicked:         (m) => {
					if (sinkControl.sink.audio.muted) {
						sinkControl.sink.audio.muted = 0
					}
					sinkControl.sink.audio.volume = Math.round(m.x)/100
				}
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

			onWheel: function(e) {
				sinkControl.sink.audio.volume = e.angleDelta.y > 0
					? Math.min(1.0, sinkControl.sink.audio.volume + 0.01)
					: Math.max(0.0, sinkControl.sink.audio.volume - 0.01)
			}
		}

		Behavior on opacity { NumberAnimation { duration: 150 } }
	}

	MouseArea {
		anchors.fill:      parent
		hoverEnabled:      true
		acceptedButtons:   Qt.LeftButton | Qt.RightButton
		onClicked:         (m) => (m.button === Qt.LeftButton)
			? sinkControl.sink.audio.muted = !sinkControl.sink.audio.muted
			: Quickshell.execDetached(["pavucontrol"])
		onEntered:         {
			sinkControl.sliderVisible = true
			sinkSliderTimeout.stop()
		}
		onPositionChanged: {
			sinkControl.sliderVisible = true
			sinkSliderTimeout.stop()
		}
		onExited:          sinkSliderTimeout.restart()
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

		onWheel: function(e) {
			sinkControl.sink.audio.volume = e.angleDelta.y > 0
				? Math.min(1.0, sinkControl.sink.audio.volume + 0.01)
				: Math.max(0.0, sinkControl.sink.audio.volume - 0.01)
		}
	}
}

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Rectangle {
	id: sourceControl

	property bool sliderVisible: false
	property var source: Pipewire.defaultAudioSource

	implicitHeight:    parent.height - 8
	implicitWidth:     parent.height - 7
	radius:            this.height / 2
	color:             Theme.bar.alt
	border.color:      Theme.bar.border
	border.width:      2
	z:                 2

	PwObjectTracker { objects: [sourceControl.source] }

	Connections {
		target: sourceControl.source?.audio ?? null
		enabled: target !== null
		function onVolumeChanged() {
			sourceControl.sliderVisible = true
			sourceSliderTimeout.restart()
		}
	}

	Timer {
		id:          sourceSliderTimeout
		interval:    1000
		repeat:      false
		onTriggered: sourceControl.sliderVisible = false
	}

	Text {
		id: sourceIcon

		anchors.centerIn: parent

		property var source: sourceControl.source

		font { family: Theme.font; pixelSize: 12; }

		color: sourceControl.source.audio.muted ? Theme.ltgrey : Theme.white
		text:  ""
	}

	Rectangle {
		anchors.verticalCenter: sourceControl.verticalCenter
		anchors.left:           sourceControl.right
		anchors.leftMargin:    -8

		implicitHeight: 20
		implicitWidth:  118
		radius:         this.height / 2
		color:          Theme.bar.bg
		border.color:   Theme.bar.border
		border.width:   2
		opacity:        sourceControl.sliderVisible ? 1 : 0
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
				id: sourceSlider

				anchors.verticalCenter: parent.verticalCenter
				anchors.left:           parent.left
				anchors.leftMargin:     1

				implicitHeight: parent.height - 2
				implicitWidth:  sourceControl.source.audio.muted ? 0 : (sourceControl.source?.audio.volume ?? 0) * 100
				radius:         this.height / 2
				color:          Theme.bar.fill
			}

			MouseArea {
				anchors.fill:      parent
				hoverEnabled:      true
				acceptedButtons:   Qt.LeftButton | Qt.RightButton
				onEntered:         sourceSliderTimeout.stop()
				onPositionChanged: sourceSliderTimeout.stop()
				onExited:          sourceSliderTimeout.restart()
				onClicked:         (m) => {
					if (sourceControl.source.audio.muted) {
						sourceControl.source.audio.muted = 0
					}
					sourceControl.source.audio.volume = Math.round(m.x)/100
				}
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

			onWheel: function(e) {
				sourceControl.source.audio.volume = e.angleDelta.y > 0
					? Math.min(1.0, sourceControl.source.audio.volume + 0.01)
					: Math.max(0.0, sourceControl.source.audio.volume - 0.01)
			}
		}
		Behavior on opacity { NumberAnimation { duration: 150 } }
	}

	MouseArea {
		anchors.fill:      parent
		hoverEnabled:      true
		acceptedButtons:   Qt.LeftButton | Qt.RightButton
		onClicked:         (m) => (m.button === Qt.LeftButton)
			? sourceControl.source.audio.muted = !sourceControl.source.audio.muted
			: Quickshell.execDetached(["pavucontrol"])
		onEntered:         {
			sourceControl.sliderVisible = true
			sourceSliderTimeout.stop()
		}
		onPositionChanged: {
			sourceControl.sliderVisible = true
			sourceSliderTimeout.stop()
		}
		onExited:          sourceSliderTimeout.restart()
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

		onWheel: function(e) {
			sourceControl.source.audio.volume = e.angleDelta.y > 0
				? Math.min(1.0, sourceControl.source.audio.volume + 0.01)
				: Math.max(0.0, sourceControl.source.audio.volume - 0.01)
		}
	}
}

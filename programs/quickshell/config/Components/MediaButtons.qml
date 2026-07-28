import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import QtQuick

Rectangle {
	id: mediaPanel

	implicitHeight:    parent.height - 12
	implicitWidth:     mediaButtons.width + 24
	color:             Theme.bar.bg
	border.color:      Theme.bar.border
	border.width:      2

	Row {
		id: mediaButtons

		anchors.centerIn:             parent
		anchors.verticalCenterOffset: 1

		spacing: 6

		Rectangle {
			anchors.verticalCenter: parent.verticalCenter

			implicitHeight: parent.height
			implicitWidth:  20
			color:          "transparent"

			Text { // Volume sink number
				id: sinkVolume
				anchors.centerIn: parent

				property var sink: Pipewire.defaultAudioSink

				PwObjectTracker { objects: [sinkVolume.sink] }

				font { family: Theme.font; pixelSize: 9; }
				property var volume: Math.round((sinkVolume.sink?.audio.volume ?? 0) * 100)

				color: sinkVolume.sink.audio.muted ? Theme.ltgrey : Theme.white
				text:  sinkVolume.sink.audio.muted ? "󰝟" : volume.toString() + "%"
			}
		}

		Rectangle { // Prev
			id: prevButton

			implicitHeight:         mediaPanel.height
			implicitWidth:          mediaPanel.height
			color:                  "transparent"

			Text {
				anchors.centerIn: parent

				property var player: Mpris.players.values.find(p => p.isPlaying) || Mpris.players.values[0]

				font { family: Theme.font; pixelSize: 13; }

				color: Theme.white
				text:  "󰒮"

				MouseArea {
					anchors.fill: parent

					property var player: parent.player

					onClicked: (player?.canGoPrevious) ? player.previous() : undefined
				}
			}
		}

		Rectangle { // Play/Pause
			id: playButton

			implicitHeight:   mediaPanel.height
			implicitWidth:    mediaPanel.height
			color:            "transparent"

			Text {
				anchors.centerIn: parent

				property var player: Mpris.players.values.find(p => p.isPlaying) || Mpris.players.values[0]

				font { family: Theme.font; pixelSize: 17; }

				color: Theme.white
				text:  (player.isPlaying) ? "󰏤" : "󰐊"

				MouseArea {
					anchors.fill: parent

					property var player: parent.player

					onClicked: player?.isPlaying ? player.pause() : player.play()
				}
			}
		}

		Rectangle { // Next
			id: nextButton

			implicitHeight:         mediaPanel.height
			implicitWidth:          mediaPanel.height
			color:                  "transparent"

			Text {
				anchors.centerIn: parent

				property var player: Mpris.players.values.find(p => p.isPlaying) || Mpris.players.values[0]

				font { family: Theme.font; pixelSize: 13; }

				color: Theme.white
				text:  "󰒭"

				MouseArea {
					anchors.fill: parent

					property var player: parent.player

					onClicked: (player?.canGoNext) ? player.next() : undefined
				}
			}
		}

		Rectangle {
			anchors.verticalCenter: parent.verticalCenter

			implicitHeight: parent.height
			implicitWidth:  20
			color:          "transparent"

			Text { // Volume source number
				id: sourceVolume

				anchors.centerIn: parent

				property var source: Pipewire.defaultAudioSource
				property var volume: Math.round((sourceVolume.source?.audio.volume ?? 0) * 100)

				PwObjectTracker { objects: [sourceVolume.source] }

				font { family: Theme.font; pixelSize: 9; }

				color: sourceVolume.source.audio.muted ? Theme.ltgrey : Theme.white
				text:  sourceVolume.source.audio.muted ? "󰝟" : volume.toString() + "%"
			}
		}
	}
}

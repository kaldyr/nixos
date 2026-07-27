// Quickshell bar for Hyprland
// vim:fdm=marker:fdl=0:foldmarker=-->,<--
//@ pragma UseQApplication
//@ pragma IconTheme Papirus-Dark
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import "Components"

// qmllint disable uncreatable-type
PanelWindow {
	id: root

	anchors {
		top:   true
		left:  true
		right: true
	}

	implicitHeight: 32
	color:  "transparent"

	property bool sliderLocked: false

	SystemClock {
		id:        sysClock
		precision: SystemClock.Seconds
	}

	// Left
	Launcher {
		id: launcher
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
	}
	Workspaces {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           launcher.right
		anchors.leftMargin:     -6
	}

	// LeftMid
	VolumeSink {
		id: volumeSink

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          mediaPanel.left
		anchors.rightMargin:    -6
	}
	MediaButtons {
		id: mediaPanel

		anchors.verticalCenter:         parent.verticalCenter
		anchors.horizontalCenter:       parent.horizontalCenter
		anchors.horizontalCenterOffset: -(parent.width / 4)
	}
	VolumeSource {
		id: volumeSource

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           mediaPanel.right
		anchors.leftMargin:     -6
	}

	// Center
	Rectangle {
		id: leftToggleBar

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          clockFace.left
		anchors.rightMargin:    -6

		implicitHeight:    parent.height - 10
		implicitWidth:     leftToggleButtons.width + 24
		topLeftRadius:     this.height / 2
		bottomLeftRadius:  this.height / 2
		color:             Theme.bar.bg
		border.color:      Theme.bar.border
		border.width:      2

		Row {
			id: leftToggleButtons

			anchors.centerIn: parent
			height:           parent.height
			spacing:          6

			Brightness { property var sliderDirection: "left" }
			Hypridle { }
		}
	}
	ClockAnalog {
		id: clockFace
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          datetime.left
		anchors.rightMargin:    -5
	}
	DateTimeBar {
		id:               datetime
		anchors.centerIn: parent
	}
	CalendarButton {
		id: calendar

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           datetime.right
		anchors.leftMargin:     -5
	}
	Rectangle {
		id: rightToggleBar

		anchors.verticalCenter: parent.verticalCenter
		anchors.left:           calendar.right
		anchors.leftMargin:     -6

		implicitHeight:    parent.height - 10
		implicitWidth:     rightToggleButtons.width + 24
		topRightRadius:    this.height / 2
		bottomRightRadius: this.height / 2
		color:             Theme.bar.bg
		border.color:      Theme.bar.border
		border.width:      2

		Row {
			id: rightToggleButtons

			anchors.centerIn: parent
			height:           parent.height
			spacing:          6

			Notifications { }
			Hyprsunset { property string sliderDirection: "right" }
		}
	}

	// RightMid
	Rectangle {
		id: networkPanel
		anchors.verticalCenter:         parent.verticalCenter
		anchors.horizontalCenter:       parent.horizontalCenter
		anchors.horizontalCenterOffset: -(parent.width * 3 / 4)
	}

	// Right
	Systemtray {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          powerButton.left
		anchors.rightMargin:    -10
	}

	PowerButton {
		id: powerButton

		anchors.verticalCenter: parent.verticalCenter
		anchors.right:          parent.right
	}
}

//@ pragma UseQApplication
import Quickshell
import "Theme"

// qmllint disable uncreatable-type
PanelWindow {
	anchors { top: true; left: true; right: true }
	implicitHeight: 32
	color:  Theme.bar
}

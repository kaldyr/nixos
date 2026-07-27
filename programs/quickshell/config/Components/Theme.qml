pragma Singleton
import QtQuick

QtObject {
	readonly property string font: "Recursive Sans Casual Static"

	readonly property color red:    "#e78284"
	readonly property color orange: "#ef9f76"
	readonly property color yellow: "#e5c890"
	readonly property color green:  "#a6d189"
	readonly property color teal:   "#81c8be"
	readonly property color sea:    "#7ec0ee"
	readonly property color blue:   "#8caaee"
	readonly property color indigo: "#9ca6f8"
	readonly property color violet: "#cba6f7"
	readonly property color white:  "#c6d0f5"
	readonly property color ltgrey: "#414559"
	readonly property color grey:   "#303446"
	readonly property color dkgrey: "#292c3c"
	readonly property color black:  "#232634"

	readonly property var bar: ({
		 bg:     grey,
		 alt:    dkgrey,
		 border: black,
		 fill:   white,
	})

	readonly property var ws: ({
		active:   teal,
		inactive: blue,
		urgent:   red,
		empty:    ltgrey,
		overview: indigo,
	})

	readonly property var clock: ({
		face:   dkgrey,
		border: violet,
		hands:  blue,
		text:   white,
	})

	readonly property var cal: ({
		bg:     dkgrey,
		border: orange,
		text:   white,
	})

	readonly property var sunset: ({
		active:   orange,
		inactive: ltgrey,
	})

	readonly property var idle: ({
		active:   teal,
		inactive: ltgrey,
	})
}

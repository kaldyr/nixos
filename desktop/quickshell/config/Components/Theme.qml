pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string scheme: Settings.appearance.colorscheme
    readonly property var colors: palette.colors

    readonly property color primary: colors[Settings.appearance.primaryAccent]
    readonly property color secondary: colors[Settings.appearance.secondaryAccent]

    FileView {
        id: paletteFile

        path: Quickshell.env("HOME") + "/.config/quickshell/ColorSchemes/" + root.scheme + ".json"

        adapter: JsonAdapter {
            id: palette

            property string name: ""
            property string mode: "dark"

            property JsonObject colors: JsonObject {
                property string red: "#e78284"
                property string orange: "#ef9f76"
                property string yellow: "#e5c890"
                property string green: "#a6d189"
                property string teal: "#81c8be"
                property string blue: "#8caaee"
                property string purple: "#cba6f7"

                property string text: "#c6d0f5"
                property string subtext: "#838ba7"
                property string surface: "#414559"
                property string base: "#303446"
                property string mantle: "#292c3c"
                property string crust: "#232634"
            }
        }
    }

    Connections {
        target: palette.colors

        function onBaseChanged() {
            console.log("Palette base changed:", palette.colors.base);
        }
    }
}

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property alias appearance: settings.appearance

    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.config/quickshell/settings.json"

        adapter: JsonAdapter {
            id: settings

            property JsonObject appearance: JsonObject {
                property string colorscheme: "catppuccin-frappe"
                property string primaryAccent: "teal"
                property string secondaryAccent: "violet"
                property string font: "Recursive Sans Casual Static"
                property int fontSize: 12
            }
        }
    }

    function save() {
        settingsFile.writeAdapter();
    }

    function toggleTheme() {
        appearance.colorscheme = appearance.colorscheme === "catppuccin-frappe" ? "rose-pine-dawn" : "catppuccin-frappe";

        save();
    }
}

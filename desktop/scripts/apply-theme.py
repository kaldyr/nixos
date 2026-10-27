#!/usr/bin/env python3

import configparser
import json
import os
import subprocess
import sys
import tempfile
from io import StringIO
from pathlib import Path

MANIFEST = Path("/etc/desktop-themes.json")
CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
SCHEMA = "org.gnome.desktop.interface"


def gsettings(key, value):
    subprocess.run(
        ["gsettings", "set", SCHEMA, key, value],
        check=True,
    )


def check_writable(*paths):
    for path in paths:
        if path.is_symlink():
            raise RuntimeError(f"Configuration is managed: {path}")


def write_file(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)

    if path.is_symlink():
        raise RuntimeError(
            f"{path} is managed by a symlink"
        )

    fd, tmp = tempfile.mkstemp(dir=path.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(content)
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


def update_ini(path, section, values):
    settings = configparser.ConfigParser(interpolation=None)
    settings.optionxform = str

    if path.exists():
        settings.read(path)

    if not settings.has_section(section):
        settings.add_section(section)

    settings[section].update(values)

    output = StringIO()
    settings.write(output)
    write_file(path, output.getvalue())


def update_gtk(values):
    for version in (3, 4):
        update_ini(
            CONFIG / f"gtk-{version}.0/settings.ini",
            "Settings",
            values,
        )


def apply_colorscheme(entry):
    dark = entry["mode"] == "dark"
    name = entry["gtk"]["name"]
    theme_path = entry["gtk"]["path"]

    if theme_path is None:
        css = "/* Default GTK4 appearance */\n"
    else:
        source = Path(theme_path) / "gtk-4.0/gtk.css"

        if not source.is_file():
            raise RuntimeError(
                f"GTK4 stylesheet not found: {source}"
            )

        css = f'@import url("{source.as_uri()}");\n'

    update_gtk({
        "gtk-theme-name": name,
        "gtk-application-prefer-dark-theme": str(dark).lower(),
    })

    write_file(CONFIG / "gtk-4.0/gtk.css", css)

    gsettings("gtk-theme", name)
    gsettings(
        "color-scheme",
        "prefer-dark" if dark else "prefer-light",
    )

    # Apply the Qt/Kvantum colorscheme.
    kvantum = entry.get("kvantum")

    if kvantum is not None:
        update_ini(
            CONFIG / "Kvantum/kvantum.kvconfig",
            "General",
            {"theme": kvantum["name"]},
        )

    print(f"Colorscheme: {entry['name']}")


def apply_icons(entry):
    name = entry["gtkName"]
    icon_path = Path(entry["path"]) / name

    if not icon_path.is_dir():
        raise RuntimeError(
            f"Icon theme not found: {icon_path}"
        )

    update_gtk({
        "gtk-icon-theme-name": name,
    })

    gsettings("icon-theme", name)

    print(f"Icon theme: {entry['name']}")


def apply_cursor(entry, size):
    name = entry["theme"]
    path = Path(entry["path"]) / name

    if not 8 <= size <= 128:
        raise ValueError("Cursor size must be between 8 and 128")

    if not (path / "manifest.hl").is_file():
        raise RuntimeError(f"Hyprcursor theme not found: {path}")

    if not (path / "cursors").is_dir():
        raise RuntimeError(f"XCursor theme not found: {path}")

    update_gtk({
        "gtk-cursor-theme-name": name,
        "gtk-cursor-theme-size": str(size),
    })

    gsettings("cursor-theme", name)
    gsettings("cursor-size", str(size))

    cursor_env = {
        "XCURSOR_THEME": name,
        "XCURSOR_SIZE": str(size),
        "HYPRCURSOR_THEME": name,
        "HYPRCURSOR_SIZE": str(size),
    }

    subprocess.run(
        [
            "dbus-update-activation-environment",
            "--systemd",
            *(f"{key}={value}" for key, value in cursor_env.items()),
        ],
        check=True,
    )

    subprocess.run(
        ["hyprctl", "setcursor", name, str(size)],
        check=True,
    )

    print(f"Cursor theme: {entry['name']} ({size}px)")


def apply_fonts(font, font_size, mono_font, mono_size):
    font = font.strip()
    mono_font = mono_font.strip()

    if not font or not mono_font:
        raise ValueError("Font names cannot be empty")

    font_size = int(font_size)
    mono_size = int(mono_size)

    if not 6 <= font_size <= 48 or not 6 <= mono_size <= 48:
        raise ValueError("Font sizes must be between 6 and 48")

    gtk_values = {"gtk-font-name": f"{font} {font_size}"}

    qt_values = {
        "general": f'"{font},{font_size}"',
        "fixed": f'"{mono_font},{mono_size}"',
    }

    update_gtk(gtk_values)

    for version in (5, 6):
        update_ini(
            CONFIG / f"qt{version}ct/qt{version}ct.conf",
            "Fonts",
            qt_values,
        )

    gsettings("font-name", f"{font} {font_size}")
    gsettings("monospace-font-name", f"{mono_font} {mono_size}")

    print(f"Main font: {font} {font_size}")
    print(f"Monospace font: {mono_font} {mono_size}")


def main():
    usage = """Usage:
  apply-theme theme <colorscheme>
  apply-theme icons <icon-theme>
  apply-theme cursor <cursor-theme> <size>
  apply-theme fonts <font> <size> <mono-font> <mono-size>
  apply-theme list [theme|icons|cursor]

Examples:
  apply-theme theme catppuccin-frappe
  apply-theme icons catppuccin-papirus-frappe-sapphire
  apply-theme cursor catppuccin-frappe-sapphire 24
  apply-theme fonts "Recursive Sans Casual Static" 11 "Maple Mono NF" 11

Aliases:
  apply-theme <colorscheme>
  apply-theme --help
"""

    args = sys.argv[1:]

    if not args or args[0] in ("-h", "--help", "help"):
        print(usage)
        return

    with open(MANIFEST, encoding="utf-8") as file:
        catalog = json.load(file)

    categories = {
        "theme": "colorschemes",
        "icons": "iconThemes",
        "cursor": "cursorThemes",
    }

    command = args[0]

    if command == "list":
        if len(args) > 2:
            raise ValueError("Usage: apply-theme list [theme|icons|cursor]")

        selected = args[1] if len(args) == 2 else None

        if selected is not None and selected not in categories:
            raise ValueError(f"Unknown category: {selected}")

        for category, key in categories.items():
            if selected is not None and category != selected:
                continue

            print(f"{category}:")
            for identifier, entry in catalog[key].items():
                print(f"  {identifier}: {entry['name']}")

        return

    check_writable(
        CONFIG / "gtk-3.0/settings.ini",
        CONFIG / "gtk-4.0/settings.ini",
        CONFIG / "gtk-4.0/gtk.css",
        CONFIG / "Kvantum/kvantum.kvconfig",
        CONFIG / "qt5ct/qt5ct.conf",
        CONFIG / "qt6ct/qt6ct.conf"
    )

    if command == "fonts":
        if len(args) != 5:
            raise ValueError(
                "Usage: apply-theme fonts "
                "<font> <size> <mono-font> <mono-size>"
            )

        apply_fonts(*args[1:])
        return

    # Preserve the existing colorscheme shorthand.
    if command not in categories and command in catalog["colorschemes"]:
        args = ["theme", command]
        command = "theme"

    if command not in categories:
        raise ValueError(f"Unknown command: {command}\n\n{usage}")

    if command == "cursor":
        if len(args) != 3:
            raise ValueError(
                "Usage: apply-theme cursor <cursor-theme> <size>"
            )
    elif len(args) != 2:
        raise ValueError(f"Usage: apply-theme {command} <name>")

    category = categories[command]
    identifier = args[1]

    entry = catalog[category].get(identifier)
    if entry is None:
        available = ", ".join(sorted(catalog[category]))
        raise ValueError(
            f"Unknown {command}: {identifier}\n"
            f"Available: {available}"
        )

    if command == "theme":
        apply_colorscheme(entry)
    elif command == "icons":
        apply_icons(entry)
    elif command == "cursor":
        apply_cursor(entry, int(args[2]))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        sys.exit(1)

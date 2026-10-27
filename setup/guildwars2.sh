#!/usr/bin/env bash
set -euo pipefail

gw2="$HOME/.wine/guild-wars-2/drive_c/Program Files/Guild Wars 2"
addons="$gw2/addons"
pathing="/state/guildwars2/addons/Taimi/pathing"

if [[ ! -d "$gw2" ]]; then
	echo "ERROR: Guild Wars 2 installation not found:" >&2
	echo "  $gw2" >&2
	exit 1
fi

if [[ -e "$addons" || -L "$addons" ]]; then
	echo "ERROR: Addons path already exists:" >&2
	echo "  $addons" >&2
	exit 1
fi

if [[ ! -d /state/guildwars2/addons/Taimi ]]; then
	echo "ERROR: Taimi addon not found. Ensure Syncthing has finished syncing." >&2
	exit 1
fi

ln -s /state/guildwars2/addons "$addons"
ln -s /state/guildwars2/pathing "$pathing"

echo "Guild Wars 2 addon links created."

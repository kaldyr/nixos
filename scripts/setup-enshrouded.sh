#!/usr/bin/env bash
set -euo pipefail

savefolder="$HOME/.local/share/Steam/steamapps/compatdata/1203620/pfx/drive_c/users/steamuser/Saved Games/Enshrouded"

# Check Enshrouded has been initialized
if [[ ! -d "$savefolder" ]]; then
	echo "ERROR: Enshrouded save folder does not exist:" >&2
	echo "  $savefolder" >&2
	echo "Install and launch Enshrouded once before running this script." >&2
	exit 1
fi

# Check default save folder contains at most one file
if [[ "$(find "$savefolder" -mindepth 1 -maxdepth 1 | wc -l)" -gt 1 ]]; then
	echo "ERROR: Unexpected files exist in the default save folder:" >&2
	echo "  $savefolder" >&2
	exit 1
fi

# Check synchronized save folder exists
if [[ ! -d /state/enshrouded ]]; then
	echo "ERROR: /state/enshrouded does not exist." >&2
	echo "Ensure Syncthing has finished syncing." >&2
	exit 1
fi

# Replace default save folder with synchronized save folder
rm -rf "$savefolder"
ln -s /state/enshrouded "$savefolder"

echo "Enshrouded save folder link created."

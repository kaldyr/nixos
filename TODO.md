# Todo list for the nix config

## Changes
- Locality of Behavior rewrite
- Syncthing
- Browser Profile sync to RAM
- Do a fresh install for mjolnir to incorporate disko
- Fix media keys in hyprland
- Add in hyprlock / hypridle
- Convert theming to nix-colors
- Get radicale running on Magrathea
- Samba Server on Magrathea
- Move all "FetchFromGithub" to flake inputs?
- Toggle laptop keyboard on Air60 (dis)connect
- nixos-hardware modules for everything
- Nix-serve, hydra, binary cache

## Things to look into
- Fnott Notifications

## Disk layout

### Magrathea

raid10 subvolumes:
"media": /media
"snapshots": /media/snaps

#### /media
btrfs raid10 array subvolume "media" zstd:8
- Audiobooks
- Books
- Movies
- Music
- TVShows
- Videos

#### /media/snapshots
btrfs raid10 array subvolme "backups"
- Receive snapshots for storage

## Syncing

### Syncthing

#### Phone <-> Magrathea
Notes
Pictures/Brightwheel
Pictures/Phone
Videos/Brightwheel
Videos/Phone

#### Gram <-> Magrathea
Documents
Notes
Pictures
- Saved
- Screenshots
- Wallpapers

#### Hofud <-> Magrathea
Documents
Notes
Pictures
- Brightwheel
- Phone
- Saved
- Screenshots
- Wallpapers
Videos
- Brightwheel
- Phone

#### Mjolnir <-> Magrathea
Documents
Notes
Pictures
- Brightwheel
- Phone
- Saved
- Screenshots
- Wallpapers
Videos
- Brightwheel
- Phone
- Saved

#### Magrathea <-> Serenity

### Git
Saved on laptop, desktop, magrathea-ssd, magrathea-raid10
- NixOS Config (also on github)
- Projects

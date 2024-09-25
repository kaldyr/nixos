# Todo list for the nix config

## Changes

- Configure btrbk to snapshot state
- Configure remote backup of snapshots
- nh nix helper
- Samba Server on Magrathea?
- Syncthing
- Browser Profile sync to RAM
- Convert theming to nix-colors
- Move all "FetchFromGithub" to flake inputs?
- Toggle laptop keyboard on Air60 (dis)connect
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

### Nextcloud

#### Phone

Notes
Pictures/Brightwheel
Pictures/Messages
Pictures/Phone
Pictures/Screenshots
Videos/Brightwheel
Videos/Messages
Videos/Phone

#### Laptop/Desktop

Documents
Notes
Pictures
- Brightwheel
- Messages
- Phone
- Saved
- Screenshots
- Wallpapers
Videos
- Brightwheel
- Messages
- Phone
- Saved

### Syncthing

- Audiobooks
- Books
- Music
- Videos/Saved

### Git

Saved on laptop, desktop, magrathea-ssd, magrathea-raid10
- NixOS Config (also on github)
- Projects

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
- Movies
- Music
- TVShows
- Videos

#### /media/snapshots

btrfs raid10 array subvolme "backups"
- Receive snapshots for storage

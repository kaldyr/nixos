# Todo list for the nix config

## Basic Changes
- Syncthing
- Go all in on Librewolf
- Browser Profile sync to RAM
- Do a fresh install for mjolnir to incorporate disko
- Fix media keys in hyprland
- Add in hyprlock / hypridle
- Convert theming to nix-colors
- Get radicale running on Magrathea
- Samba Server on Magrathea
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
- Sync
- TVShows
- Videos

#### /media/snapshots
btrfs raid10 array subvolme "backups"
- Receive snapshots for storage

## Syncing

### Nextcloud
Saved on laptop, desktop, magrathea-ssd
Snapshot daily to magrathea-raid10
- Documents
- Notes
- Pictures
- Videos
    - Canon
    - Brightwheel
    - Phone

### Syncthing
Saved on laptop, desktop, and magrathea-raid10
- ~/Books ==> magrathea:/media/Books
- ~/Music ==> magrathea:/media/Music
- ~/Videos/Saved ==> magrathea:/media/Videos

### Git
Saved on laptop, desktop, magrathea-ssd, magrathea-raid10
- NixOS Config (also on github)
- Projects

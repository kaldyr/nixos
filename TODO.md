# Todo list for the nix config

## Basic Changes
- Go all in on Librewolf
- Fix media keys in hyprland
- Browser Profile sync to RAM
- Syncthing
- Move all "FetchFromGithub" to flake inputs?
- Convert theming to nix-colors
- Add in hyprlock / hypridle
- Get nextcloud running on Magrathea
- Samba Server on Magrathea
- Toggle laptop keyboard on Air60 (dis)connect

## Things to look into
- Fnott Notifications

## Disk layout

### Magrathea

"nextcloud" : btrfs subvolume : /var/lib/nextcloud
"mysql" : xfs partition : /var/lib/mysql

raid10 subvolumes:
"media": /media
"snapshots": /media/snaps

#### /media
btrfs raid10 array subvolume "media"
- Audiobooks
- Books
- Movies
- Music
- TVShows
- Videos
High Compression

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

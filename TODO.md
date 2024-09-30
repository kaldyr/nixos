# Todo list for the nix config

## Changes

- Configure btrbk to snapshot state and archive
- nh nix helper
- Samba Server on Magrathea?
- Browser Profile sync to RAM
- Convert theming to nix-colors
- Move all "FetchFromGithub" to flake inputs?
- Toggle laptop keyboard on Air60 (dis)connect
- Nix-serve, hydra, binary cache
- Beets with plugins (bandcamp)
- Get phone to automount when plugged in

## Things to look into

- Fnott Notifications

## Snapshot Map

### Laptop/Desktop
Hourly Snaps
@state -> @snaps

Archive Snaps
Nightly
@snaps -> magrathea:/storage/@snaps

### Magrathea
Hourly Snaps
@state -> @snaps
@nextcloud -> @snaps

Archive Snaps
Nightly
@snaps -> /storage/@snaps

Off-site Archive
Weekly
/storage/@snaps -> serenity:/storage/@snaps

### Serenity
Hourly Snaps
@state -> @snaps

Archive Snaps
@snaps -> /storage/@snaps

Off-site Archive
Weekly
/storage/@snaps -> magrathea:/storage/@snaps

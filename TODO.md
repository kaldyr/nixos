# Todo list for the nix config

## Changes

- Configure btrbk to snapshot state and archive
- nh nix helper
- Browser Profile sync to RAM
- Convert theming to nix-colors
- Move all "FetchFromGithub" to flake inputs?
- Toggle laptop keyboard on Air60 (dis)connect
- Nix-serve, hydra, binary cache
- Beets with plugins (bandcamp)
- Get phone to automount when plugged in
- Re-evaluate what is stored on /nix and /state

## @nix vs @state
The @state subvolume will be snapshotted for backup/restore
The @nix subvolume is just preserved between boots.
Content on @nix is stuff that either is handled by nextcloud sync
    or stuff that needs to be preserved between boots, but
    not essential to presered between installs.

### @state
/var/lib/nextcloud

### @nix
All personal home folder documents and files are synced with nextcloud


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

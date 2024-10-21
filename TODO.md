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
The @nix subvolume is just preserved between boots  
Content on @nix is stuff that either is handled by nextcloud sync  
or stuff that needs to be preserved between boots, but  
not essential to preserved between installs.  
Remove /system from the state

### @state
/var/lib/nextcloud
/var/lib/forgejo
postgresqlBackup -> /state/postgres/

## Things to look into

- Fnott Notifications

## Snapshot Map

### Magrathea
- Hourly: @state -> @snaps
- Nightly: @snaps -> /storage/@snaps
- Weekly: /storage/@snaps -> serenity:/storage/@snaps

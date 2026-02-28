# Todo list for the nix config

## Changes

- Unify motions between terminal, hyprland, and terminal applications
- Configure btrbk to snapshot state and archive
- Nix-serve, hydra, binary cache
- Beets with plugins (bandcamp)
- Get phone to automount when plugged in
- Re-evaluate what is stored on /nix and /state
- MOVE ALL FOLDERS FROM STATE TO NIX

## Keybind motions
- All keybinds should follow the same pattern
- Everything relating to hyprland on Meta/Super/Win/Whatever key
- Everything relating to mux on Alt key
- Everything application specific on Ctrl key
- Shift is extra modifier
- Submaps for Hyprland

## @nix vs @state
- The @state subvolume will be snapshotted for backup/restore
- The @nix subvolume is just preserved between boots
- Content on @nix is stuff that either is handled by nextcloud sync  
or stuff that needs to be preserved between boots, but  
not essential to preserved between installs.  
- Remove /system from the state

### @state
- /var/lib/nextcloud
- /var/lib/forgejo
- postgresqlBackup service -> /state/postgres/

## Things to look into

- Fnott Notifications
- Wired Notifications: Toqozz/wired-notify
- Walker application launcher: abenz1267/walker
- Stylix theme application: danth/stylix

## Snapshot Map

### Magrathea
- Hourly: @state -> @snaps
- Nightly: @snaps -> /storage/@snaps
- Weekly: /storage/@snaps -> serenity:/storage/@snaps

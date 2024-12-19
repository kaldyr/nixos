# Todo list for the nix config

## Changes

- Unify motions between wezterm, hyprland, and terminal applications
- Script to manage opening files in yazi with editor in a new buffer (or split) if editor open in terminal pane
- Configure btrbk to snapshot state and archive
- Browser Profile sync to RAM
- Nix-serve, hydra, binary cache
- Beets with plugins (bandcamp)
- Get phone to automount when plugged in
- Re-evaluate what is stored on /nix and /state

## Keybind motions
- All keybinds should follow the same pattern
- Everything relating to hyprland on Meta/Super/Win/Whatever key
- Everything relating to mux on Alt key
- Everything application specific on Ctrl key
- Shift is extra modifier
- Submaps for Hyprland

### Special case for editor window
- Pane navigation in wezterm should instead be script

#### Script
The idea here is to make pretend like each editor pane is a terminal pane.  
Is current terminal pane an editor pane?
- Yes: Is current editor pane on the edge?
-   Yes: Navigate to next terminal pane.
-   No: Navigate to next editor pane.
- No: Is new terminal pane an editor pane?
-   Yes: Navigate to the closest editor pane to the prev terminal pane.
-   No: Navigate to next terminal pane.

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

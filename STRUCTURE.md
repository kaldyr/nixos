---
id: STRUCTURE
aliases: []
tags: []
---
# Desktop layout

- Single SSD
- Ephemeral root partition
- Bind mount preserved files/folders to partitions on drive

## Btrfs partition subvolumes

### @home

#### Recovery strategy

##### Disposable / Downloadable:

- Steam games (Download from Steam)
- Wine games (Download and reinstall through Lutris)
- Virtual Machines (nodatacow for folder, reinstall from ISOs)

##### User data:

- Books - Syncthing
- Browser Profile - Syncthing
- Documents - Syncthing
- Keepass Database - Syncthing
- Music - Syncthing
- Notes - Syncthing
- Pictures - Syncthing
- Projects - Git
- Roms - Syncthing
- Videos - Syncthing
- User keyrings or keys - ?

### @nix

- /nix/config (System configuration) - From git
- /nix/store (The actual Nix system) - Build the system

### @state

Persistent machine state

- Age key for unlocking secrets at boot - Archive copy into usb installer
- NetworkManager connections
- Bluetooth pairing
- systemd
- fprintd fingerprint images (mjolnir)
- machine-id

Features:
- Persisted between boots
- Needed for boot (Files will be there during boot process)
- Desktops are not snapshotted as content is considered disposable if machine needs reinstall
- Snapshots could be taken and sent to server RAID @snaps for archiving to preserve

### @swap (swap partition)

# Server layout

- Single SSD
- RAID storage array
- Ephemeral root partition
- Bind mount preserved files/folders to partitions on drive

## SSD partition subvolumes

### @data

Features:
- Snapshots taken and sent to RAID @snaps

#### User Data

- Managed by Syncthing
- Canonical copy is on user's device.

Folder Examples:
- Browser Profile
- Documents
- Keepass Database
- Notes
- Pictures
- Videos

#### Shared Data

- Managed by Syncthing
- Canonical copy is on Server.

Folder Examples:
- Documents
- Obsidian Vaults
- Shared Project Folders

### @home

User and Application State:
- Application cache
- command history

Features:
- Persisted between boots
- Snapshot this subvol and send it to RAID @snaps

### @nix

- /nix/config (System configuration)
- /nix/store (The actual Nix system)

### @postgres

PostgreSQL live database

Features:
- COW disabled
- Cannot be snapshotted
- PostgresBackup files dumped to @state

### @state

Persistent machine state and data needed for recovery

- Content needs to be preserved between boots
- Content is tied to machine state
- Age key for unlocking secrets at boot
- NetworkManager connections
- systemd
- machine-id
- Config or Data folders for services (Radicale, Immich, linkwarden, etc)
- Folder postgresql backups are sent to

Features:
- Persisted between boots
- Needed for boot (Files will be there during boot process)
- Snapshot this subvolume and send it to RAID @snaps for backup

### @swap (swap partition)

## RAID partition subvolumes

### @media

Immutable media library

- Audiobooks
- Books
- Movies
- Music
- Radio
- Roms
- Shows
- Videos

### @snaps (snapshot storage)

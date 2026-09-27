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
- Virtual Machines (reinstall from ISOs)

##### User data:

- Browser Profile - Syncthing
- Documents - Syncthing
- Password Database (Keepass) - Syncthing
- Pictures - Syncthing
- Projects - Git
- Vaults (Obsidian) - Syncthing
- Videos - Syncthing (Jellyfin?)
- User keyrings or keys - Git/Syncthing

### @nix

- /nix/config (System configuration) - From git
- /nix/store (The actual Nix system) - Build the system

### @state

Persistent machine state

- Age key for unlocking secrets at boot (Stored in git via sops or generate new and update config)
- NetworkManager connections (Just connect again)
- Bluetooth pairing (Just pair again)
- systemd (Disposable)
- fprintd fingerprint images (Just scan again)
- machine-id (Disposable)

Features:
- Persisted between boots
- Needed for boot (Files will be there during boot process)
- Desktops are not snapshotted as content is considered disposable if machine needs reinstall

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
- Shared Documents
- Shared Obsidian Vaults
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
- PostgresBackup files dumped to @state for snapshots

### @state

Persistent machine state and data needed for recovery

- Age key for unlocking secrets at boot
- NetworkManager connections
- systemd
- machine-id
- Config or Data folders for services (Radicale, Immich, linkwarden, etc)
- Folder postgresql backups are sent to
- Service state folders (/var/lib/<service>/, etc)

Features:
- Persisted between boots
- Needed for boot (Files will be there during boot process)
- Snapshot this subvolume and send it to RAID @snaps for backup
- Send snapshots to off-site backup RAID

### @swap (swap partition)

## RAID partition subvolumes

### @media

Immutable media library for services

- Audiobooks (AudioBookShelf)
- Books (AudioBookShelf)
- Movies (Kodi or Jellyfin)
- Music (Navidrome)
- Radio (AudioBookShelf)
- Roms (RomM)
- Shows (Kodi or Jellyfin)
- Videos (Kodi or Jellyfin)

### @snaps (snapshot storage)

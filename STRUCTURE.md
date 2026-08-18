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
- Roms Syncthing
- Videos Syncthing
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

# Migrating

## Create @state, generate new age key, convert to new method

- [x] Mount the btrfs partition without subvol flag
- [x] Create a new subvolume @state
- [x] Umount the partition
- [x] Add the partition to the disko definition
- [x] Add the needed for boot flag
- [x] Mount @state to /state
- [x] Create a folder (root:root:0700) /state/age
- [x] Generate keys.txt 'age-keygen -o keys.txt'
- [x] Put public key in the unlock list for .sops.yaml
- [x] sops update keys
- [x] Move the current sops key definition from /systems/default.nix to each individual machine
- [x] Only for current machine: change the sops.age.keyFile to /state/age/keys.txt
- [ ] Remove the needed for boot flag to /etc/ssh
- [x] Create a folder (root:root:0755) /state/ssh
- [x] cp /etc/ssh/ssh_host_ed25519_key /state/ssh
- [x] Update machine.nix to have services.openssh.hostKeys.path = "/state/ssh/ssh_host_ed25519_key";
- [ ] Reboot and verify
- [ ] Remove the disko @etc_ssh declaration
- [ ] Unmount /etc/ssh
- [ ] Mount the btrfs partition without subvol flag
- [ ] Delete the @etc_ssh subvol
- [ ] Rebuild and reboot

## machine-id

- [ ] cp /etc/machine-id /state
- [ ] Remove the environment.persistence file /etc/machine-id
- [ ] Define the Bind
- [ ] Rebuild
- [ ] Reboot

## The rest of /nix/system
- [ ] copy the folders from /nix/system to /state
- [ ] Change the config to be "/state"
- [ ] Rebuild

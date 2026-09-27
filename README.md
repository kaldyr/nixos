# NixOS Config

## Table of Contents

1. [Machines](#machines)
1. [Notable Customizations](#notable-customizations)
1. [TODO](#todo)
1. [Install](#install)
1. [Boot Install Media](#boot-install-media)
1. [Identify Target Disk](#identify-target-disk)
1. [Edit Disko Config](#edit-disko-config)
1. [Partition Disk](#partition-disk)
1. [Add New Machine](#add-new-machine)
1. [Build the System](#build-the-system)
1. [Reboot into the New System](#reboot-into-the-new-system)

## Description

This is a multi-system and multi-user flake. It has laptops, desktops, and home server.  
The goal is a simple configuration where possible and application native config for more involved apps.  
Syncthing is used to clone user data to the servers for snapshots.  
Re-installing a machine automatically syncs data back from servers.

# Machines

## Aziraphale
- Laptop: Dell 14 D14260 Intel Core Ultra 5 225U
- Fresh Install: 
- Updated: 

### TODO
- [ ] Get everything setup

## Espresso
- Desktop: Minisforum UM790 Pro
- Fresh Install: July 14th, 2026
- Updated: 2026-09-23

### TODO
- [ ] Add razer mouse profile

## Hofud
- Desktop: Framework 13 11th Gen i5-1135G7 motherboard
- Fresh Install: (Down, waiting on parts)
- Updated: 

### TODO
- [ ] Figure out the HDMI issue
- [ ] Fresh install
- [ ] Configure as homeschool computer

## Installer
- USB Flash Drive (Actual install, not ISO)
- Fresh Install: September 5th, 2026
- Updated: 2026-09-20

### Tools
- Everything needed to install and troubleshoot machines
- Memtest

## Magrathea
- Home server: Intel i5-2500k still kicking
- Fresh Install: August 16th, 2024
- Updated: 2026-09-23

### Services
- Nextcloud (Remove soon)
- Immich (Will replace nextcloud)
- Radicale (Will replace nextcloud)
- Syncthing
- Forgejo (Private Git) served to tailnet
- Linkwarden served to tailnet (Bookmarks and Site Archiving)
- Kodi Media Center via HDMI to TV
- Technitium dns for tailnet
- Open Starbound

### TODO
- [ ] Migrate drive definitions
- [ ] Configure automatic snapshots
- [ ] AudioBookShelf
- [x] Navidrome
- [ ] Vikunja
- [ ] Immich
- [ ] Radicale

## Mjolnir
- Laptop: First generation Framework 13
- Fresh Install: July 16th, 2026
- Updated: 2026-09-23

### Upgrades
- Panther Lake Ultra x7 358H with B390 Mainboard
- 32GB LPCAMM2 7500 RAM
- BE211 Wi-Fi 7 Module
- 4.0kg Hinge Kit

### TODO
- [ ] Work on Quickshell setup

## Normandy
- Desktop: Ryzen 7 3700X, Radeon RX 7600
- Fresh Install: September 2nd, 2026
- Updated: 2026-09-23

### TODO
- [ ] Stabilize OpenRGB

## Serenity
- Home server: Ryzen 2400g
- Fresh Install: August 31st, 2026
- Updated: 2026-09-23

### Services
- Off-site backup
- Kodi
- NAS with Samba

### TODO
- [ ] Migrate drive definitions (In person, must use installer)
- [ ] Set up snapshot archiving from Magrathea

# Notable customizations

## Keybinds  
- Keyd used to remap capslock to escape and a custom layer
- Unified keybinds between applications

- Modifiers:  
Hyprland: META/Windows/Whatever key  
Terminal: Alt (leftalt)  
Applications: Ctrl

hjkl - movement  
Caps+hjkl - arrow keys  
, - tab previous  
. - tab next

# TODO

## Replace Nextcloud

- [ ] Radicale for CalDAV + CardDAV
- [ ] Immich for photo management, sync from phones, sharing with family
- [x] Syncthing for file/folder syncing, browser profile backup

# Install

## Boot Install Media

## Identify Target Disk
```fish
lsblk -o NAME,SIZE,MODEL,SERIAL

```

## Edit Disko Config
```fish
nvim /nix/config/disko/<system>.nix

```

Completions will suggest the disk, just start typing the path and choose the match.

## Partition Disk
```fish
nix run github:nix-community/disko/latest -- --mode destroy,format,mount /nix/config/disko/<system>.nix

```

### Manual Interventions

Disko should not manage raid arrays on purpose. Running the above command would wipe data.

#### Magrathea

```fish
mkfs.btrfs -m raid10 -d raid10 /dev/sdW /dev/sdX /dev/sdY /dev/sdZ
mkdir -p /storage
mount /dev/sdW /storage
cd /storage
btrfs subvolume create @media
btrfs subvolume create @snaps
cd ..
umount /storage

```

After disko runs and mounts the SSD partitions, but before installing the system:

```fish
chattr +C /var/lib/postgresql

```

#### Serenity

```fish
mkfs.btrfs -m raid1 -d raid1 /dev/sdY /dev/sdZ
mkdir -p /storage
mount /dev/sdY /storage
cd /storage
btrfs subvolume create @media
btrfs subvolume create @snaps
cd ..
umount /storage

```

## Add New Machine

Skip if machine is already defined.  

### Add machine to flake.nix

### Configure User

Create or update '/nix/config/users/<user>.nix'.  
Set preferences.  

### Configure System

Create '/nix/config/systems/<system>.nix'.  

#### Generate the hardware config
```fish
sudo nixos-generate-config --root /mnt --show-hardware-config

```
#### Merge into /nix/config/systems/<system>.nix

- boot.initrd.availableKernelModules
- boot.kernelModules
- boot.extraModulePackages (if applicable)
- Filesystems
- Graphics/hardware configuration

### Generate Machine Identity

```fish
sudo -E sops /nix/config/secrets.yaml
```

Navigate to the age keys section and add a line for <system>

```vim
:r! age-keygen
```

Format correctly.  
Yank the new public key to the clipboard.  

```vim
:e /nix/config/.sops.yaml
```

Add the new system and its public key

```vim
:w
<c-x>
```

Navigate to syncthing section

```vim
:r! generate-syncthing-identity <system>
17k
dd
:e /nix/config/services/syncthing/magrathea.nix
/dev<cr>
p
vi{gs
<c-x>
:wq
```

```fish
sudo -E sops updatekeys secrets.yaml
```

- Create /nix/config/services/syncthing/<system>.nix and populate its folders.
- Add the new device ID to Magrathea.
- Add the new device to Magrathea's folder sync list.
- Update any other machines that need to know about the new system.
- Rebuild affected existing machines.

## Build the System

```fish
install-system <system>
```

### Manual Interventions

#### Virtual Machines
If you don't need to snapshot the VMs, disable COW for the image folder BEFORE any files are in the folder

```fish
chattr +C /local/Machines
```

## Reboot into the New System

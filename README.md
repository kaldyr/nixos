# NixOS Config

## Table of Contents

1. [Machines](#machines)
1. [Notable Customizations](#notable-customizations)
1. [TODO](#todo)
1. [Install](#install)
1. [Boot Install Media](#boot-install-media)
1. [Partition the Drive](#partition-the-drive)
1. [Setup the Config Folder](#setup-the-config-folder)
1. [Build the Base System](#build-the-base-system)
1. [Reboot into the New System](#reboot-into-the-new-system)

## Description

This is a multi-system and multi-user flake. It has laptops, desktops, and home server.  
The goal is a simple configuration where possible and application native config for more involved apps.  
Syncthing is used to clone user data to the servers for snapshots.  
Re-installing a machine automatically syncs data back from servers.

# Machines

## Aziraphale
- Laptop: Dell 14 D14260 Intel Core Ultra 5 225U
- Fresh Install: September 19th, 2026
- Updated: September 19th, 2026

### TODO
- [ ] Get everything setup

## Espresso
- Desktop: Minisforum UM790 Pro
- Fresh Install: July 14th, 2026
- Updated: 2026-09-14

### TODO
- [ ] Add razer mouse profile

## Hofud
- Desktop: Framework 13 11th Gen i5-1135G7 motherboard
- Fresh Install: (Down, waiting on parts)
- Updated: 2026-09-14

### TODO
- [ ] Figure out the HDMI issue
- [ ] Fresh install
- [ ] Congigure as homeschool computer

## Installer
- USB Flash Drive (Actual install, not ISO)
- Fresh Install: September 5th, 2026
- Updated: 2026-09-14

### Tools
- Everything needed to install and troubleshoot machines
- Memtest

## Magrathea
- Home server: Intel i5-2500k still kicking
- Fresh Install: August 16th, 2024
- Updated: 2026-09-14

### Services
- Nextcloud (Remove soon)
- Immich (Will replace nextcloud)
- Radicale (Will replace nextcloud)
- Syncthing
- Forgejo (Private Git) served to tailnet
- Linkwarden served to tailnet (Bookmarks and Site Archiving)
- Kodi Media Center to TV and streaming media to devices
- Technitium dns for tailnet
- Open Starbound
- NAS with Samba

### TODO
- [ ] Migrate drive definitions
- [ ] Configure automatic snapshots
- [ ] Install and configure Immich
- [ ] Install and configure Radicale
- [ ] Install and configure Vikunja

## Mjolnir
- Laptop: First generation Framework 13
- Fresh Install: July 16th, 2026
- Updated: 2026-09-14

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
- Updated: 2026-09-14

### TODO
- [ ] Stabilize OpenRGB

## Serenity
- Home server: Ryzen 2400g
- Fresh Install: August 31st, 2026
- Updated: 2026-09-14

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

## Partition the Drive

```fish
disko --mode destroy,format,mount /nix/config/disko/[system].nix
```

### Manual Interventions

Disko does not manage raid arrays on purpose. Running the above command would wipe data.

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
mount /dev/sdW /storage
cd /storage
btrfs subvolume create @media
btrfs subvolume create @snaps
cd ..
umount /storage
```

## Setup the Config Folder

### Generate the default config (Just to get hardware config)

```fish
nixos-generate-config --root /mnt
```

## Install the configuration

```fish
mkdir /mnt/nix/config
git clone https://github.com/kaldyr/nixos /mnt/nix/config
```

### Merge the generated hardware config

- Make sure the correct graphics drivers are listed
- Make sure the filesystems are correct
- Make sure the state version is correct in system and home manager

### Install or Generate Private Keys

- Drop the keys in the /mnt system for system and user
- Generate public keys and user sops key
- If generating new keys, add them into the .sops.yaml and `sudo -E sops updatekeys secrets.yaml`

## Build the Base System

```fish
cd /mnt
nixos-install --no-root-password --flake /mnt/nix/config#[machine]
nixos-enter
```

### Manual Interventions

#### Samba Servers

```fish
sudo smbpasswd -a USERNAME
```

#### Virtual Machines

If you don't need to snapshot the VMs, disable COW for the image folder BEFORE any files are in the folder

```fish
chattr +C /local/Machines
```

## Reboot into the New System

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

This is a multi-system and multi-user flake. It has laptops, desktops, and home servers.  
The goal is a simple configuration where possible and application native config for more involved apps.  
Syncthing is used to clone user data to the servers for snapshots.  
Re-installing a machine automatically syncs user data back from servers on first boot.  
Media is hosted by private services, most of which have offline cache available to clients.  

# Machines

Update: 2026-09-28
- [x] Aziraphale
- [x] Espresso
- [x] Installer
- [x] Magrathea
- [x] Mjolnir
- [x] Normandy
- [x] Serenity

## Aziraphale
- Laptop: Dell 14 D14260 Intel Core Ultra 5 225U
- Fresh Install: October 3rd, 2026

## Espresso
- Desktop: Minisforum UM790 Pro
- Fresh Install: July 14th, 2026

## Hofud
- Desktop: Framework 13 11th Gen i5-1135G7 mainboard
- Fresh Install:

### TODO
- Solder the new RTC Battery when it arrives
- Figure out the HDMI/USB-C Monitor issue

## Installer
- USB Flash Drive (Actual install, not ISO)
- Fresh Install: September 5th, 2026

### Features
- Persisted networkmanager and tailscale autoconnect to services
- Syncthing keeps keepass database and /nix/config current
- Any changes made during the installation process auto-synced to other computers

## Magrathea
- Home server: Intel i5-2500k still kicking
- Fresh Install: August 16th, 2024

### Services
- Nextcloud (Remove soon)
- AudioBookoShelf (Audiobooks and ebooks)
- Forgejo (Private Git)
- Linkwarden (Bookmarks and Site Archiving)
- Navidrome (Music)
- Syncthing Hub (with versioning and snapshot archives)
- Technitium (DNS for tailnet with ad block)
- Vikunja (Tasks and Project Management)
- Kodi Media Center via HDMI to TV
- Open Starbound Server

### TODO
- Migrate drive definitions
- Configure automatic snapshots
- Radicale (service)
- Give Vikunja access to a shared calendar on Radicale
- Immich (service)
- Miniflux (service)
- RomM (service)
- Terraria server
- Look into Jellyfin
- Purge content from media folders we just don't consume anymore
- Clean out old backup folders
- Consolidate all the old files into new folder structures

## Mjolnir
- Laptop: First generation Framework 13
- Fresh Install: July 16th, 2026

### Upgrades
- Panther Lake Ultra x7 358H Mainboard
- 32GB LPCAMM2 7500 RAM
- BE211 Wi-Fi 7 Module
- 4.0kg Hinge Kit

## Normandy
- Desktop: Ryzen 7 3700X, Radeon RX 7600
- Fresh Install: September 2nd, 2026

### TODO
- Stabilize OpenRGB
- Stabilize Epson Printer (perhaps a folder is not persisted correctly?)
- WinStitch (May need Windows VM)
- MacOS VM with printer drivers for borderless printing of 12x12 photo pages

## Serenity
- Home server: Ryzen 2400g
- Fresh Install: August 31st, 2026

### Services
- Off-site backup
- Kodi
- NAS with Samba

### TODO
- Migrate drive definitions (In person, must use installer)
- Setup snapshot archiving from Magrathea
- Investigate viability of cloning media from Magrathea
- Investigate moving to Jellyfin client

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

## Syncthing
- Personal folders for desktop users are synced to file server.
- Documents and Obsidian Vaults have simple file versioning for file server only.
- btrfs snapshots sent to local RAID array and offsite RAID array.

# TODO

## Replace Nextcloud

- [x] Syncthing for file/folder syncing, browser profile backup
- [ ] Radicale for CalDAV + CardDAV
- [ ] Immich for photo management, sync from phones, sharing with family

# Install

## Boot Install Media

## Identify Target Disk
```fish
lsblk

```

## Edit Disko Config
```fish
nvim /nix/config/disko/<system>.nix

```

Completions will suggest the disk, just start typing the path and choose the match.

## Partition Disk
```fish
disko --mode destroy,format,mount /nix/config/disko/<system>.nix

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

Current SSD is too small to house @data so toss it on the array for now.

```fish
mkfs.btrfs -m raid1 -d raid1 /dev/sdY /dev/sdZ
mkdir -p /storage
mount /dev/sdY /storage
cd /storage
btrfs subvolume create @data
btrfs subvolume create @media
btrfs subvolume create @snaps
cd ..
umount /storage

```

## Add New Machine

Skip if machine is already defined.  

### Configure User

Create or update '/nix/config/users/<user>.nix'.  
Set preferences.  

### Configure System

#### Add Machine to Main Flake

/nix/config/flake.nix

#### Create Machine Specific Config

/nix/config/systems/<system>.nix

#### Generate the hardware config in neovim
```vim
<c-w>v
:e /tmp/hardware.nix<CR>
r! sudo nixos-generate-config --root /mnt --show-hardware-config

```

#### Merge into /nix/config/systems/<system>.nix

- boot.initrd.availableKernelModules
- boot.kernelModules
- boot.extraModulePackages (if applicable)
- Filesystems
- Graphics/hardware configuration

#### Delete the buffer

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
```

Cut the <system>.id line to the clipboard.

```vim
:e /nix/config/services/syncthing/magrathea.nix
```

Paste the <system>.id line into the devices section and sort.  

```vim
:w
<c-x>
```

Repeat for any other systems that will interact with the new system.  

```vim
:wq
```

```fish
sudo -E sops updatekeys secrets.yaml
```

- Create /nix/config/services/syncthing/<system>.nix and populate its folders.
- Add the new device to Magrathea's folder sync list.
- Rebuild affected existing machines once Syncthing propagates config changes.

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

## Connect to Tailscale

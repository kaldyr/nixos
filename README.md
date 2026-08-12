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

# Machines

## ☕ Espresso
- Desktop: Minisforum UM790 Pro
- Hyprland

## ⚔ Hofud
- Desktop: Framework 13 11th Gen i5-1135G7 motherboard
- Currently down while waiting for parts
- Hyprland

## 🪐 Magrathea
- Home server: Intel i5-2500k still kicking
- Nextcloud  (Remove soon)
- Immich  (Soon, to replace nextcloud)
- Radicale  (Soon, to replace nextcloud)
- Syncthing  (Soon, to replace nextcloud)
- Forgejo (Gitea) served to tailnet
- Linkwarden served to tailnet
- Technitium dns for tailnet
- Open Starbound
- Kodi
- NAS with Samba

## 🔨 Mjolnir
- Laptop: Framework 13 Intel Core Ultra x7 358H in 1st gen chassis
- Hyprland

## 🚀 Normandy
- Desktop: Ryzen 7 3700X, Radeon RX 7600
- Trial to save this machine from windows hell
- Hyprland

## 🍵Oolong
- Laptop: Dell Inspiron
- Budgie

## 🚀 Serenity
- Home server: Ryzen 2400g
- Off-site backup
- Kodi
- NAS with Samba

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

# [TODO]

## Installation Media

- Custom Installation media
- Has full nix store pre built for every machine output
- Fully offline install capable
- Hyprland environment with all familiar customiazations
- All tools required to build pre-installed (disko, etc)

## Replace Nextcloud

- Radicale for CalDAV + CardDAV
- Immich for photo management, sync from phones, sharing with family
- Syncthing for file/folder syncing, browser profile backup
- ~Linkwarden for bookmarks~ DONE

## Finally work with snapshots

# Install

## Boot Install Media

## Partition the Drive

```fish
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /path/to/[system].nix
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
- If generating new keys, add them into the .sops.yaml and `sops updatekeys secrets.yaml`

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

## Reboot into the New System

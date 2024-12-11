# NixOS Installation

## Table of Contents
1. [Description](#description)
1. [Boot Install Media](#boot-install-media)
1. [Partition the Drive](#partition-the-drive)
1. [Setup the Config Folder](#setup-the-config-folder)
1. [Build the Base System](#build-the-base-system)
1. [Reboot into the New System](#reboot-into-the-new-system)

## Description

This is a multi-system and multi-user flake.  It has laptops, desktops, and home server.
- ☕ Espresso  
Desktop: Ryzen 5700g  
- ⚔ Gram  
Laptop: Framework 13 11th Gen Intel i5  
- 🪐 Magrathea  
Home server: Intel i5-2500k still kicking  
Nextcloud  
Forgejo (Gitea)  
Kodi  
- 🔨 Mjolnir  
Desktop: Minisforum UM790 Pro  
- 🍵Oolong  
Laptop: Dell Inspiron  
- 🚀 Serenity  
Home server: Ryzen 2400g  
Off-site backup  
Kodi  

## Boot Install Media

## Partition the Drive  
```fish
disko -- --mode disko /usb/disko/[system].nix
```
### Manual Interventions
Disko does not manage raid arrays on purpose.  Running the above command would wipe data.

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
### Install the configuration
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
- If generating new keys, add them into the .sops.yaml and ```sops updatekeys secrets.yaml```

## Build the Base System
```fish
cd /mnt
nixos-install --no-root-password --flake /mnt/nix/config#[machine]
nixos-enter
```
### Manual Interventions

#### Samba
```fish
sudo smbpasswd -a USERNAME
```
## Reboot into the New System

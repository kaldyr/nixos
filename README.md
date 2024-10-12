# NixOS Installation

## Table of Contents
1. [Boot Install Media](#boot-install-media)
1. [Partition the Drive](#partition-the-drive)
1. [Setup the Config Folder](#setup-the-config-folder)
1. [Build the Base System](#build-the-base-system)
1. [Reboot into the New System](#reboot-into-the-new-system)

## Boot Install Media

## Partition the Drive  
```fish
disko -- --mode disko /usb/disko/[system].nix
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
## Reboot into the New System

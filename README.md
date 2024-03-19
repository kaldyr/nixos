# NixOS Installation

## Table of Contents
1. [Boot Install Media](#boot-install-media)
1. [Partition the Drive](#partition-the-drive)
1. [Setup the Config Folder](#setup-the-config-folder)
1. [Build the Base System](#build-the-base-system)
1. [Reboot into the New System](#reboot-into-the-new-system)
1. [Building the custom ISO Image](#building-the-custom-iso-image)

## Boot Install Media

## Configure the Shell
```bash
sudo -Es
mkdir /usb
mount /dev/[usb] /usb
mkdir -p ~/.config/sops/age
cryptsetup open /usb/locked.img keys
mount /dev/mapper/keys ~/.config/sops/age
```
## Partition the Drive  
```bash
disko -- --mode disko /usb/disko/[system].nix
```
## Setup the Config Folder

### Generate the default config (Just to get hardware config)  
```bash
nixos-generate-config --root /mnt
```
### Install the configuration
```bash
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
- If generating new keys, add them into the .sops.yaml and sops updatekeys secrets.yaml

## Build the Base System
```bash
cd /mnt
nixos-install --no-root-password --flake /mnt/nix/config#[machine]
nixos-enter
```
## Reboot into the New System

## Building the Custom ISO Image
```bash
nix run nixpkgs#nixos-generators -- --format iso --flake /nix/config#installer -o nixos.iso
```

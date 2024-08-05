{ lib, modulesPath, pkgs, sysConfig, ... }: {

    imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        ./desktop.nix
        ../programs/hyprland.nix
    ];

    environment.systemPackages = with pkgs; [
        btrfs-progs
        cryptsetup
        disko
        mdadm
        parted
    ];

    hardware.pulseaudio.enable = lib.mkForce false;
    networking.hostName = sysConfig.hostname;
    networking.wireless.enable = false;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = sysConfig.arch;

}

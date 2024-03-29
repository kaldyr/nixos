{ lib, pkgs, modulesPath, sysConfig, ... }: {

    imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        ./modules/desktop.nix
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

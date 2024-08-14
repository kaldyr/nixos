{ inputs, lib, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-laptop
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/mpd.nix
        ../programs/plymouth.nix
        ../programs/steam.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ]; # Fill out when installing
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];

        loader.grub = {
            default = 2;
            gfxmodeEfi = "1920x1200,1920x1080";
            useOSProber = lib.mkForce true;
        };

        supportedFilesystems = [ "ntfs" ];

    };

    environment.systemPackages = with pkgs; [ tailscale ];
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    networking.hostName = sysConfig.hostname;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

    services = {

        auto-cpufreq = {

            enable = true;

            settings = {
                battery.governor = "powersave";
                battery.turbo = "never";
                charger.governor = "performance";
                charger.turbo = "auto";
            };

        };

        fwupd.enable = true;

        libinput = {
            enable = true;
            touchpad.scrollMethod = "twofinger";
            touchpad.accelSpeed = "-0.5";
        };

        tailscale.enable = true;
        thermald.enable = true;

    };

}

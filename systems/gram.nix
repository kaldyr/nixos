{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
        ../disko/gram.nix
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/mpd.nix
        ../programs/nextcloud-client.nix
        ../programs/plymouth.nix
        ../programs/steam.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ]; # Fill out when installing
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];
        loader.grub.gfxmodeEfi = "2256x1504";
    };

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

        thermald.enable = true;

    };

}

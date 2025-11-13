{ inputs, lib, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
        ../disko/hofud.nix
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/lutris.nix
        ../programs/nextcloud-desktop.nix
        ../programs/openscad.nix
        ../programs/plymouth.nix
        ../programs/steam.nix
        ../programs/wezterm.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "i915.enable_fbc=1" "i915.enable_psr=1" "quiet" ];
        loader.grub = {
            default = 2;
            gfxmodeEfi = "2256x1504";
            useOSProber = lib.mkForce true;
        };
        loader.timeout = null;
        supportedFilesystems = [ "ntfs" ];
    };

    fileSystems = {
        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=6G" "mode=755" ];
        };
        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
    };

    hardware = {
        cpu.amd.updateMicrocode = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
    };

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
        libinput.touchpad.scrollMethod = "twofinger";
        libinput.touchpad.accelSpeed = "-0.5";
        thermald.enable = true;
        xserver.videoDrivers = [ "amdgpu" ];
    };

}

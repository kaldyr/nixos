{ inputs, lib, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
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
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
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

    fileSystems = {
        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=6G" "mode=755" ];
        };
        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
        "/windows" = {
            device = "/dev/disk/by-uuid/B6F2645BF264223B";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" ];
        };
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

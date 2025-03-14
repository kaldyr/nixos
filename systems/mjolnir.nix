{ inputs, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        ../disko/mjolnir.nix
        ./desktop.nix
        ../services/mpd.nix
        ../services/openrazer.nix
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
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
        initrd.kernelModules = [ "amdgpu" ];
        kernel.sysctl."vm.max_map_count" = 16777216;
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" "preempt=full" ];
        loader.grub.gfxmodeEfi = "3440x1440,1920x1080";
    };

    # environment.systemPackages = with pkgs; [ lowfi ];

    fileSystems = {

        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=16G" "mode=755" ];
        };

        "/etc/ssh".neededForBoot = true;

        "/home" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=1G" "mode=755" ];
        };

        "/nix".neededForBoot = true;

    };

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

}

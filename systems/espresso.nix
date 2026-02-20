{ inputs, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        ../disko/espresso.nix
        ./desktop.nix
        ../programs/budgie.nix
        ../programs/lutris.nix
        ../programs/plymouth.nix
        ../programs/steam.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
        initrd.kernelModules = [ "amdgpu" ];
        kernel.sysctl."vm.max_map_count" = 16777216;
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" "preempt=full" ];
        loader.grub.gfxmodeEfi = "1920x1080";
    };

    fileSystems = {
        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=16G" "mode=755" ];
        };
        "/etc/ssh".neededForBoot = true;
        "/home".neededForBoot = true;
        "/nix".neededForBoot = true;
    };

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

}

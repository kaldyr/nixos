{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        ../disko/serenity.nix
        ../programs/kodi.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = []; # Fill out from generated hardware-configuration.nix when installing
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];
        loader.grub.gfxmodeEfi = "3840x2160";
    };

    fileSystems = {

        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=2G" "mode=755" ];
        };

        "/etc/ssh".neededForBoot = true;

        "/home" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=256M" "mode=755" ];
        };

        "/nix".neededForBoot = true;
        "/state".neededForBoot = true;

        "/storage/media" = {
            device = ""; # Put the uuid of one of the disks in the array
            fsType = "btrfs";
            options = [ "subvol=@media" "noatime" "compress-force=zstd:8" ];
        };

        "/storage/snaps" = {
            device = ""; # Put the uuid of one of the disks in the array
            fsType = "btrfs";
            options = [ "subvol=@snaps" "noatime" "compress-force=zstd:8" ];
        };

    };

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

}

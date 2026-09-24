{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./desktop.nix
    ../programs/discord
    ../programs/hyprland
    ../programs/lutris
    ../programs/newsboat
    ../programs/plymouth
    ../programs/steam
    ../services/keyd
    ../services/kmscon
    ../services/openrazer
    ../services/syncthing
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ehci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];

      kernelModules = [ "amdgpu" ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/2cce94ea-7cec-4f93-97f9-72e21c73aedf";
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    kernelParams = [
      "btrfs"
      "quiet"
      "preempt=full"
      "iommu=pt"
    ];

    loader.grub.gfxmodeEfi = "1920x1080";
  };

  environment.systemPackages = with pkgs; [
    floorp-bin
    nano
    xarchiver
  ];

  fileSystems =
    let
      driveOptions = [ "noatime" "discard=async" "compress=zstd:1" ];
    in
  {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=16G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/025C-BF4E";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/804a850d-5c93-41a8-87fe-b88fcad48b6f";
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ driveOptions;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/804a850d-5c93-41a8-87fe-b88fcad48b6f";
      fsType = "btrfs";
      options = [ "subvol=@nix" ] ++ driveOptions;
    };

    "/state" = {
      device = "/dev/disk/by-uuid/804a850d-5c93-41a8-87fe-b88fcad48b6f";
      fsType = "btrfs";
      options = [ "subvol=@state" ] ++ driveOptions;
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/804a850d-5c93-41a8-87fe-b88fcad48b6f";
      fsType = "btrfs";
      options = [ "subvol=@swap" ] ++ driveOptions;
    };
  };

  hardware.bluetooth.enable = lib.mkForce false;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-shares-plugin
      thunar-volman
      tumbler
    ];
  };

  services.tumbler.enable = true;

  time.timeZone = "America/Los_Angeles";
}

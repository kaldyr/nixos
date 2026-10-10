{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./desktop.nix
    ../programs/gedit
    ../programs/hyprland
    ../programs/lutris
    ../programs/openstarbound
    ../programs/plymouth
    ../programs/steam
    ../services/kmscon
    ../services/syncthing
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ehci_pci"
        "ahci"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ "amdgpu" ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/1f577724-db59-4ba2-a08e-2457a5a669b5";
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    kernelParams = [
      "zswap.max_pool_percent=15"
    ];

    loader.grub.gfxmodeEfi = "1920x1080";
  };

  # environment.systemPackages = with pkgs; [ ];

  fileSystems =
    let
      cryptedDrive = "/dev/disk/by-uuid/d3846810-5870-4b83-8334-161280ac5632";
      driveOptions = [ "noatime" "discard=async" "compress=zstd:3" ];
    in
  {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/93C7-AF7E";
      fsType = "vfat";
    };

    "/home" = {
      device = cryptedDrive;
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ driveOptions;
    };

    "/nix" = {
      device = cryptedDrive;
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@nix" ] ++ driveOptions;
    };

    "/state" = {
      device = cryptedDrive;
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@state" ] ++ driveOptions;
    };

    "/swap" = {
      device = cryptedDrive;
      fsType = "btrfs";
      options = [ "subvol=@swap" ] ++ driveOptions;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  swapDevices = [{ device = "/swap/swapfile"; }];
  time.timeZone = "America/Los_Angeles";
}

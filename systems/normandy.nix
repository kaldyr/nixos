{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./desktop.nix
    ../programs/ageofempiresonline
    ../programs/discord
    ../programs/gedit
    ../programs/hyprland
    ../programs/lutris
    ../programs/openstarbound
    ../programs/plymouth
    ../programs/steam
    ../programs/virtualmachines
    ../services/epson-et-8550
    ../services/keyd
    ../services/kmscon
    ../services/openrgb
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ "amdgpu" ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/3ac2d4ea-c2fc-44d1-9a16-f9237d94d22e";
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

    loader.grub.gfxmodeEfi = "2560x1440";
  };

  environment.systemPackages = with pkgs; [
    orca-slicer
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
      device = "/dev/disk/by-uuid/80A9-6B15";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d200e034-f61b-4e7e-8aa1-81e322690d28";
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ driveOptions;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/d200e034-f61b-4e7e-8aa1-81e322690d28";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@nix" ] ++ driveOptions;
    };

    "/state" = {
      device = "/dev/disk/by-uuid/d200e034-f61b-4e7e-8aa1-81e322690d28";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@state" ] ++ driveOptions;
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/d200e034-f61b-4e7e-8aa1-81e322690d28";
      fsType = "btrfs";
      options = [ "subvol=@swap" ] ++ driveOptions;
    };
  };

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  swapDevices = [{ device = "/swap/swapfile"; }];
  time.timeZone = "America/Los_Angeles";
}

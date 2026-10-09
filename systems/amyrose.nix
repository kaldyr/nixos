{
  inputs,
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
        # [MARK]
      ];

      kernelModules = [ "amdgpu" ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/"; # [MARK]
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "" ]; # [MARK]
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    kernelParams = [
      "zswap.max_pool_percent=15"
    ];

    loader.grub.gfxmodeEfi = "1920x1080";
  };

  # environment.systemPackages = with pkgs; [ ];

  fileSystems =
    let
      cryptedDrive = "/dev/disk/by-uuid/"; # [MARK]
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
      device = "/dev/disk/by-uuid/"; # [MARK]
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

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  swapDevices = [{ device = "/swap/swapfile"; }];
  time.timeZone = "America/Los_Angeles";
}

{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  boot = {
    initrd = {
      availableKernelModules = [
      ];

      kernelModules = [ "xe" ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/";
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    kernelParams = [
      "btrfs"
      "quiet"
    ];

    loader.grub.gfxmodeEfi = "1920x1200";
  };

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
      device = "/dev/disk/by-uuid/";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/";
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ driveOptions;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@nix" ] ++ driveOptions;
    };

    "/state" = {
      device = "/dev/disk/by-uuid/";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@state" ] ++ driveOptions;
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/";
      fsType = "btrfs";
      options = [ "subvol=@swap" ] ++ driveOptions;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

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
    xserver.videoDrivers = [ "modesetting" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];
  time.timeZone = "America/Los_Angeles";
}

{
  inputs,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./desktop.nix
    ../programs/gedit
    ../programs/hyprland
    ../programs/plymouth
    ../services/syncthing
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/00800c31-8e9d-438a-8a72-3a548a370e4f";
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
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8B75-B44E";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/ce1cdbac-9ff3-4df7-9ad1-40c8bdf29556";
      fsType = "btrfs";
      options = [ "subvol=@home" ] ++ driveOptions;
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/ce1cdbac-9ff3-4df7-9ad1-40c8bdf29556";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@nix" ] ++ driveOptions;
    };

    "/state" = {
      device = "/dev/disk/by-uuid/ce1cdbac-9ff3-4df7-9ad1-40c8bdf29556";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@state" ] ++ driveOptions;
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/ce1cdbac-9ff3-4df7-9ad1-40c8bdf29556";
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

  home-manager.users.${sysConfig.user}.home.packages = with pkgs; [
    firefox
    libation
    onlyoffice-desktopeditors
  ];

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

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
    ../services/kmscon
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
        device = "/dev/disk/by-uuid/59814d16-fbfe-4343-b941-90d846693514";
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "zswap.max_pool_percent=25" ];
    loader.grub.gfxmodeEfi = "1920x1200";
  };

  fileSystems =
    let
      cryptedDrive = "/dev/disk/by-uuid/56d29b6f-0c61-4bce-a2dc-f59bbce32165";
      driveOptions = [ "noatime" "discard=async" "compress=zstd:1" ];
    in
  {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2866-BA21";
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

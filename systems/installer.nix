{
  lib,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ./desktop.nix
    ../programs/hyprland
    ../programs/plymouth
    ../services/keyd
    ../services/kmscon
    ../services/pipewire
    ../services/syncthing
  ];

  boot = {
    blacklistedKernelModules = [ "xe" ];

    initrd = {
      luks.devices.usbcrypted = {
        device = "/dev/disk/by-uuid/d92dbb21-4cc0-499a-ba4a-4068013b0d24";
        allowDiscards = true;
      };

      systemd = {
        enable = true;
        emergencyAccess = true;
      };

      availableKernelModules = [ "usb_storage" ];
    };

    kernelParams = [ "zswap.max_pool_percent=50" ];

    loader = {
      efi.canTouchEfiVariables = lib.mkForce false;

      grub = {
        efiInstallAsRemovable = lib.mkForce true;
        memtest86.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    age
    btrfs-progs
    cryptsetup
    disko
    dislocker
    dosfstools
    e2fsprogs
    efibootmgr
    exfatprogs
    git
    gparted
    gptfdisk
    inxi
    libva-utils
    mesa-demos
    nixos-install-tools
    ntfs3g
    parted
    pciutils
    rsync
    sops
    usbutils
    util-linux
    wimlib
    xfsprogs
  ];

  fileSystems =
    let
      cryptedDrive = "/dev/disk/by-uuid/3a06b88b-5747-4f76-a4d8-8dc52bf284bc";
      driveOptions = [ "noatime" "discard=async" "compress=zstd:3" ];
      driveSubvols = {
        "/nix" = "@usbnix";
        "/state" = "@usbstate";
        "/storage" = "@usbstorage";
      };
    in
    {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "defaults" "size=2G" "mode=755" ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/7584-2D95";
        fsType = "vfat";
      };
    }
    // builtins.mapAttrs (mountpoint: subvol: {
      device = cryptedDrive;
      fsType = "btrfs";
      options = [ "subvol=${subvol}" ] ++ driveOptions;
      neededForBoot = builtins.elem mountpoint [ "/nix" "/state" ];
    }) driveSubvols;

  hardware = {
    graphics.enable = true;
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  home-manager.users.${sysConfig.user}.home.persistence."/state".directories = [
    ".cache/yazi/packages"
    ".local/share/keyrings"
    ".local/share/nvim/site/pack/core/opt"
    ".passwords"
    ".ssh"
    "Pictures/Wallpapers"
  ];

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ {
        command = "ALL";
        options = [ "NOPASSWD" ];
      } ];
    }
  ];

  time.timeZone = "America/Los_Angeles";
}

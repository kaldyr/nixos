{
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ./desktop.nix
    ../programs/hyprland
    ../services/keyd
    ../services/kmscon
  ];

  boot = {
    initrd = {
      luks.devices.usbcrypted = {
        device = "/dev/disk/by-id/usb-Samsung_Flash_Drive_FIT_0321821050004118-0:0-part2";
        allowDiscards = true;
      };

      systemd = {
        enable = true;
        emergencyAccess = true;
      };

      availableKernelModules = [
        "ahci"
        "cryptd"
        "dm_crypt"
        "dm_mod"
        "ehci_pci"
        "nvme"
        "ohci_pci"
        "sd_mod"
        "sr_mod"
        "uas"
        "uhci_hcd"
        "usb_storage"
        "usbcore"
        "usbhid"
        "xhci_pci"
      ];
    };

    kernelParams = [
      "btrfs"
      "zswap.enabled=1"
      "zswap.max_pool_percent=50"
      "zswap.compressor=zstd"
      "zswap.zpool.zsmalloc"
    ];

    loader.grub = {
      enable = true;
      memtest86.enable = true;
    };
  };

  environment = {
    shellAliases = {
      "disko" = "sudo nix run github:nix-community/disko/latest --";
      "installnix" = "sudo nixos-install --no-root-password --flake";
    };

    systemPackages = with pkgs; [
      age
      btrfs-progs
      cryptsetup
      dosfstools
      e2fsprogs
      exfatprogs
      git
      gparted
      gptfdisk
      libva-utils
      mesa-demos
      nixos-install-tools
      ntfs3g
      parted
      pciutils
      sops
      usbutils
      util-linux
      xfsprogs
    ];
  };

  fileSystems =
    let
      driveOptions = [
        "noatime"
        "discard=async"
        "compress=zstd:3"
      ];
    in
  {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;

      options = [
        "defaults"
        "size=4G"
        "mode=755"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-id/usb-Samsung_Flash_Drive_FIT_0321821050004118-0:0-part1";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/mapper/usbcrypted";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@usbnix" ] ++ driveOptions;
    };

    "/state" = {
      device = "/dev/mapper/usbcrypted";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@usbstate" ] ++ driveOptions;
    };

    "/storage" = {
      device = "/dev/mapper/usbcrypted";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@usbstorage" ] ++ driveOptions;
    };
  };

  home-manager.users.${sysConfig.user}.home.persistence."/state".directories = [
    "/home/${sysConfig.user}/.cache/yazi/packages"
    "/home/${sysConfig.user}/.local/share/nvim/site/pack/core/opt"
    "/home/${sysConfig.user}/.passwords"
    "/home/${sysConfig.user}/.ssh"
    "/home/${sysConfig.user}/Pictures/Wallpapers"
  ];

  time.timeZone = "America/Los_Angeles";
}

{
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ../disko/installer.nix
    ./desktop.nix
    ../programs/hyprland
    ../services/keyd
    ../services/kmscon
  ];

  boot = {
    extraModulePackages = with pkgs; [ btrfs-progs ];

    initrd.systemd = {
      enable = true;
      emergencyAccess = true;
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

    supportedFilesystems = [
      "btrfs"
      "ntfs"
    ];
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

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [
      "defaults"
      "size=4G"
      "mode=755"
    ];
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

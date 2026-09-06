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
    initrd.systemd.enable = true;

    kernelParams = [
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

  environment.persistence."/state".directories = [
    {
      directory = "/home/${sysConfig.user}/.cache/yazi/packages";
      user = "matt";
      group = "users";
      mode = "0750";
    }
    {
      directory = "/home/${sysConfig.user}/.local/share/nvim/site/pack/core/opt";
      user = "matt";
      group = "users";
      mode = "0750";
    }
    {
      directory = "/home/${sysConfig.user}/.passwords";
      user = "matt";
      group = "users";
      mode = "0700";
    }
    {
      directory = "/home/${sysConfig.user}/.ssh";
      user = "matt";
      group = "users";
      mode = "0700";
    }
    {
      directory = "/home/${sysConfig.user}/Pictures/Wallpapers";
      user = "matt";
      group = "users";
      mode = "0750";
    }
  ];

  time.timeZone = "America/Los_Angeles";
}

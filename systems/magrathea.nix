{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.hardkernel-odroid-h4
    # ../desktop/jellyfin
    ../services/audiobookshelf
    ../services/forgejo
    ../services/jellyfin
    ../services/linkwarden
    ../services/miniflux
    ../services/openstarbound
    ../services/pipewire
    ../services/radicale
    ../services/syncthing
    ../services/technitium
    ../services/transmission
  ];

  boot = {
    blacklistedKernelModules = [ "xe" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
      ];

      kernelModules = [ "i915" ];
    };

    kernel.sysctl."kernel.sysrq" = 1;
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "i915.enable_dc=0"
      "zswap.max_pool_percent=25"
    ];

    loader.grub.gfxmodeEfi = "1920x1080";
  };

  environment.systemPackages = with pkgs; [
    edac-utils
    flac
    libcec
    picard
  ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D57C-9547";
      fsType = "vfat";
    };
  }
  // builtins.mapAttrs (mountpoint: subvol: { # SSD
    device = "/dev/disk/by-uuid/eff878ef-e2bf-4f0f-9d24-e60fd7c5ba6e";
    fsType = "btrfs";
    neededForBoot = builtins.elem mountpoint [ "/cache" "/nix" "/state" ];
    options = [ "subvol=${subvol}" "defaults" "noatime" "discard=async" "compress=zstd:3" ];
  }) {
    "/cache" = "@cache";
    "/data" = "@data";
    "/home" = "@home";
    "/nix" = "@nix";
    "/scratch" = "@scratch";
    "/state" = "@state";
    "/swap" = "@swap";
    "/var/lib/postgresql" = "@postgres";
  }
  // builtins.mapAttrs (mountpoint: subvol: { # HDD Array
    device = "/dev/disk/by-uuid/c3cb725e-8cee-4690-a44d-114100497133";
    fsType = "btrfs";
    options = [ "subvol=${subvol}" "defaults" "noatime" "compress=zstd:8" "nofail" ];
  }) {
    "/storage/media" = "@media";
    "/storage/snaps" = "@snaps";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  services.tailscale.useRoutingFeatures = "server";
  swapDevices = [ { device = "/swap/swapfile"; } ];
  users.groups."media" = { };
  users.users.matt.extraGroups = [ "media" ];
  time.timeZone = "America/Los_Angeles";
}

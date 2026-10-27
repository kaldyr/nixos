{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ../services/audiobookshelf
    ../services/forgejo
    ../services/jellyfin
    ../services/kodi
    ../services/linkwarden
    ../services/miniflux
    ../services/openstarbound
    ../services/radicale
    ../services/syncthing
    ../services/technitium
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "sdhci_pci"
    ];

    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "zswap.max_pool_percent=25" ];
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
    options = [ "subvol=${subvol}" "defaults" "noatime" "compress=zstd:8" ];
  }) {
    "/storage/media" = "@media";
    "/storage/snaps" = "@snaps";
  };

  hardware = {
    alsa.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };

    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services = {
    pipewire.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce false;
    tailscale.useRoutingFeatures = "server";
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
  users.groups."media" = { };
  users.users.matt.extraGroups = [ "media" ];
  time.timeZone = "America/Los_Angeles";
}

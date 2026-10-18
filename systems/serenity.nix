{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ../services/audiobookshelf
    ../services/jellyfin
    ../services/kodi
    ../services/syncthing
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    initrd.kernelModules = [ "amdgpu" ];
    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "zswap.max_pool_percent=25" ];
    loader.grub.gfxmodeEfi = "3840x2160,1920x1080";
  };

  environment.systemPackages = with pkgs; [ usbutils ];

  fileSystems =
    let
      hddDrive = "/dev/disk/by-uuid/27fb138d-b3c1-4b8f-9110-04a28bcda82c";
      hddOptions = [ "defaults" "noatime" "compress=zstd:8" ];
      hddSubvols = {
        "/data" = "@data";
        "/media" = "@media";
        "/snaps" = "@snaps";
      };

      ssdDrive = "/dev/disk/by-uuid/4af0da80-4c95-40a3-a98b-f5c157f9c8c3";
      ssdOptions = [ "defaults" "noatime" "discard=async" "compress=zstd:3" ];
      ssdSubvols = {
        "/cache" = "@cache";
        "/home" = "@home";
        "/nix" = "@nix";
        "/scratch" = "@scratch";
        "/state" = "@state";
        "/swap" = "@swap";
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
        device = "/dev/disk/by-uuid/8429-E6AD";
        fsType = "vfat";
      };
    }
    // builtins.mapAttrs (mountpoint: subvol: {
      device = ssdDrive;
      fsType = "btrfs";
      options = [ "subvol=${subvol}" ] ++ ssdOptions;
      neededForBoot = builtins.elem mountpoint [ "/cache" "/nix" "/state" ];
    }) ssdSubvols
    // builtins.mapAttrs (mountpoint: subvol: {
      device = hddDrive;
      fsType = "btrfs";
      options = [ "subvol=${subvol}" ] ++ hddOptions;
    }) hddSubvols;

  hardware = {
    alsa.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services = {
    pipewire.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce false;

    samba = {
      enable = true;
      package = pkgs.samba;

      openFirewall = true;

      settings = {
        global = {
          "encrypt passwords" = true;
          "invalid users" = [ "root" ];
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "netbios name" = "serenity";
          "security" = "user";
          "server string" = "serenity";
          "workgroup" = "WORKGROUP";
        };

        "media" = {
          path = "/media";
          comment = "Media";
          browsable = "yes";
          public = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "force user" = "matt";
          "force group" = "users";
          "create mask" = "0664";
          "directory mask" = "0775";
        };
      };
    };

    samba-wsdd.enable = true;
    samba-wsdd.openFirewall = true;
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  systemd = {
    services.media-acl = {
      description = "Set ACLs for media";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig.Type = "oneshot";

      script = ''
        ${pkgs.acl}/bin/setfacl -m g:media:rwx /media
        ${pkgs.acl}/bin/setfacl -d -m g:media:rwx /media
        ${pkgs.acl}/bin/setfacl -d -m m::rwx /media
      '';
    };

    tmpfiles.rules = [
      "d /media/Audiobooks 2775 root media -"
    ];
  };

  users.groups."media" = { };
  users.users.matt.extraGroups = [ "media" ];

  users.users.matt.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZaLmcX48cycOns/c0IKlxc3ftSdCT12pbkeUnmEBWd janice@aziraphale"
  ];

  time.timeZone = "America/Los_Angeles";
}

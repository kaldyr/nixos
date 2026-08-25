{
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
    ../disko/serentiy.nix
    ../services/kodi
  ];

  boot = {
    extraModulePackages = with pkgs; [ btrfs-progs ];
    initrd.availableKernelModules = [];
    initrd.kernelModules = [ "amdgpu" ];
    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "btrfs" ];
    loader.grub.gfxmodeEfi = "3840x2160,1920x1080";
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=6G"
        "mode=755"
      ];
    };

    "/media" = {
      device = "/dev/disk/by-uuid/CHANGEME";
      fsType = "btrfs";
      options = [
        "subvol=@media"
        "noatime"
        "compress-force=zstd:8"
      ];
    };

    "/snaps" = {
      device = "/dev/disk/by-uuid/CHANGEME";
      fsType = "btrfs";
      options = [
        "subvol=@snaps"
        "noatime"
        "compress-force=zstd:8"
      ];
    };
  };

  hardware = {
    alsa.enable = true;
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

  time.timeZone = "America/Los_Angeles";
}

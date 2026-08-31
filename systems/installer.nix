{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ./desktop.nix
    ../programs/gedit
    ../programs/hyprland
    ../services/keyd
    ../services/kmscon
  ];

  boot.initrd = {
    luks.devices = lib.mkForce {
      "age".device = "/dev/disk/by-uuid/65a8e53b-98f9-4ef2-91c2-a4834825555e";
    };
    systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    age
    cryptsetup
    disko
    git
    gptfdisk
    util-linux
    sops
  ];

  systemd = {
    mounts = [
      {
        what = "/dev/disk/by-uuid/1c20b92b-8bbc-4b15-94f6-a8f9619dccf8";
        where = "/nix/config";
        type = "ext2";
        wantedBy = [ "local-fs.target" ];
      }
      {
        what = "/dev/mapper/age";
        where = "/state/age";
        type = "ext2";
        wantedBy = [ "local-fs.target" ];
      }
    ];

    targets.graphical.requires = [
      "nix-config.mount"
      "state-age.mount"
    ];
  };

  time.timeZone = "America/Los_Angeles";
}

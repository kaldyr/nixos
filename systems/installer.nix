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

  fileSystems."/nix/config" = lib.mkForce {
    device = "/dev/disk/by-uuid/1c20b92b-8bbc-4b15-94f6-a8f9619dccf8";
    fsType = "ext2";
  };

  fileSystems."/state/age" = lib.mkForce {
    device = "/dev/mapper/age";
    fsType = "ext2";
  };

  time.timeZone = "America/Los_Angeles";
}

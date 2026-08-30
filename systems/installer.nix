{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ./desktop.nix
    ../programs/gedit
    ../programs/hyprland
    ../programs/plymouth
    ../services/keyd
    ../services/kmscon
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "dm_mod"
        "xts"
        "aesni_intel"
      ];

      luks.devices."state" = {
        device = "/dev/disk/by-uuid/3ad6da6c-7cd9-4480-91fa-83dc1fa40e5f";
        allowDiscards = false;
      };
    };

    zfs.forceImportRoot = false;
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

  fileSystems."/state/age" = {
    device = "/dev/mapper/state";
    fsType = "btrfs";
    neededForBoot = true;
  };

  services = {
    libinput.touchpad.scrollMethod = "twofinger";
    libinput.touchpad.accelSpeed = "-0.5";
  };

  time.timeZone = "America/Los_Angeles";
}

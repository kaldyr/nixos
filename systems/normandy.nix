{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ../disko/normandy.nix
    ./desktop.nix
    ../programs/ageofempiresonline
    ../programs/discord
    ../programs/gedit
    ../programs/hyprland
    ../programs/lutris
    ../programs/nextcloud
    ../programs/openstarbound
    ../programs/plymouth
    ../programs/steam
    ../programs/virtualmachines
    ../services/epson-et-8550
    ../services/kmscon
  ];

  boot = {
    extraModulePackages = with pkgs; [ btrfs-progs ];
    initrd.availableKernelModules = [ ]; # Fill out
    initrd.kernelModules = [ "amdgpu" ];
    kernel.sysctl."vm.max_map_count" = 16777216;
    kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1000; # AoeO
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [
      "btrfs"
      "quiet"
      "preempt=full"
      "iommu=pt"
    ];
    loader.grub.gfxmodeEfi = "2560x1440";
  };

  environment.systemPackages = with pkgs; [ orca-slicer ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [
      "defaults"
      "size=16G"
      "mode=755"
    ];
  };

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  time.timeZone = "America/Los_Angeles";
}

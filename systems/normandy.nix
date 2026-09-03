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
    ../programs/openstarbound
    ../programs/plymouth
    ../programs/steam
    ../programs/virtualmachines
    ../services/epson-et-8550
    ../services/kmscon
    ../services/openrgb
  ];

  boot = {
    extraModulePackages = with pkgs; [ btrfs-progs ];

    initrd.availableKernelModules = [
      "nvme"
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

    kernelParams = [
      "btrfs"
      "quiet"
      "preempt=full"
      "iommu=pt"
    ];

    loader.grub.gfxmodeEfi = "2560x1440";
  };

  environment.systemPackages = with pkgs; [
    orca-slicer
  ];

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

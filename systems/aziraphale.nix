{
  inputs,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ../desktop
    ../programs/gedit
    ../programs/plymouth
    ../services/auto-cpufreq
    ../services/syncthing
    ../services/kmscon
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ ];

      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/59814d16-fbfe-4343-b941-90d846693514";
        allowDiscards = true;
      };
    };

    kernel.sysctl."vm.max_map_count" = 16777216;
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "zswap.max_pool_percent=25" ];
    loader.grub.gfxmodeEfi = "1920x1200";
  };

  environment.systemPackages = with pkgs; [
    firefox
    libation
  ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2866-BA21";
      fsType = "vfat";
    };
  }
  // builtins.mapAttrs (mountpoint: subvol: {
    device = "/dev/disk/by-uuid/56d29b6f-0c61-4bce-a2dc-f59bbce32165";
    fsType = "btrfs";
    neededForBoot = builtins.elem mountpoint [ "/nix" "/state" ];
    options = [ "subvol=${subvol}" "noatime" "discard=async" "compress=zstd:1" ];
  }) {
    "/home" = "@home";
    "/nix" = "@nix";
    "/state" = "@state";
    "/swap" = "@swap";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];

    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  home-manager.users.${sysConfig.user}.systemd.user.services.libation-cleanup =
    let
      libationCleanup = pkgs.writeShellScript "libation-cleanup" ''
        if [[ -d "$HOME/Downloads/Libation" ]]; then
          ${pkgs.findutils}/bin/find "$HOME/Downloads/Libation" \
            -mindepth 1 \
            -maxdepth 1 \
            -exec ${pkgs.coreutils}/bin/rm -rf -- {} +
        fi
      '';
    in
    {
      Install.WantedBy = [ "default.target" ];
      Unit.Description = "Clean Libation staging directory";

      Service = {
        Type = "oneshot";
        ExecStart = libationCleanup;
      };
    };

  services = {
    libinput.touchpad.scrollMethod = "twofinger";
    libinput.touchpad.accelSpeed = "-0.5";
    thermald.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
  time.timeZone = "America/Los_Angeles";
}

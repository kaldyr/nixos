{
  inputs,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
    ../disko/mjolnir.nix
    ./desktop.nix
    ../programs/ageofempiresonline
    ../programs/gedit
    ../programs/hyprland
    ../programs/lutris
    ../programs/nextcloud
    ../programs/openstarbound
    ../programs/plymouth
    ../programs/retroarch
    ../programs/steam
    ../programs/virtualmachines
    ../services/epson-et-8550
    ../services/keyd
    ../services/kmscon
    ../services/llama-cpp
    ../services/openrazer
  ];

  boot = {
    extraModulePackages = with pkgs; [ btrfs-progs ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ "xe" ];
    kernel.sysctl."vm.max_map_count" = 16777216;
    kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1000; # AoeO
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [
      "btrfs"
      "quiet"
      "xe.enable_psr=0"
    ];
    loader.grub.gfxmodeEfi = "3440x1440,2256x1504,1920x1080";
  };

  # environment.persistence."/state".directories = [ "/var/lib/fprint" ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

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

  hardware = {
    cpu.intel.npu.enable = true;
    cpu.intel.updateMicrocode = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ openscad ];

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/framework_tool";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services = {
    auto-cpufreq = {
      enable = true;
      settings = {
        battery.governor = "powersave";
        battery.turbo = "never";
        charger.governor = "performance";
        charger.turbo = "auto";
      };
    };

    libinput.touchpad.scrollMethod = "twofinger";
    libinput.touchpad.accelSpeed = "-0.5";

    pipewire.wireplumber.extraConfig."50-device-priority" = {
      "wireplumber.settings" = {
        "device.restore-profile" = false;
        "node.restore-default-targets" = false;
      };

      "monitor.alsa.rules" = [
        {
          matches = [ { "device.name" = "alsa_card.pci-0000_00_1f.3"; } ];
          actions.update-props = {
            "api.acp.auto-profile" = true;
            "api.acp.auto-port" = true;
          };
        }
        {
          matches = [ { "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; } ];
          actions."update-props"."priority.session" = 1000;
        }
        {
          matches = [ { "node.name" = "alsa_output.pci-0000_00_1f.3.hdmi-stereo"; } ];
          actions."update-props"."priority.session" = 1500;
        }
      ];

      "monitor.bluez.rules" = [
        {
          matches = [ { "node.name" = "~bluez_output.*"; } ];
          actions."update-props"."priority.session" = 2000;
        }
      ];
    };

    thermald.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };

  time.timeZone = "America/Los_Angeles";
}

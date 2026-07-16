{ lib, inputs, pkgs, sysConfig, ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
        ../disko/mjolnir.nix
        ./desktop.nix
        ../programs/hyprland
        ../programs/lutris
        ../programs/nextcloud
        ../programs/openscad
        ../programs/openstarbound
        ../programs/plymouth
        ../programs/retroarch
        ../programs/steam
        ../programs/virtualmachines
        ../services/epson-et-8550
        ../services/keyd
        ../services/kmscon
        ../services/openrazer
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [  ]; # Fill out
        initrd.kernelModules = [ ]; # Fill out
        kernel.sysctl."vm.max_map_count" = 16777216;
        kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1000; # AoeO
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ]; # Fill out
        loader.grub.gfxmodeEfi = "3440x1440,2256x1504,1920x1080";
    };

    environment.persistence."/nix".users.${sysConfig.user} = lib.mkIf sysConfig.homeImpermanence {
        directories = [ "DnD" ];
    };

    fileSystems = {
        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=16G" "mode=755" ];
        };
        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
    };

    hardware = {
        cpu.intel.updateMicrocode = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
    };

    networking.firewall.allowedUDPPortRanges = [ { from = 1000; to = 1005; } ]; # AoeO

    # networking = {
    #     bridges."br0".interfaces = [ "enp1s0" ];
    #     interfaces."br0".ipv4.addresses = [{
    #         address = "10.0.0.231";
    #         prefixLength = 24;
    #     }];
    #     defaultGateway = "10.0.0.1";
    #     nameservers = [ "10.0.0.1" "9.9.9.9" ];
    # };

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
        thermald.enable = true;
        xserver.videoDrivers = [ "i915" ];
    };

    time.timeZone = "America/Los_Angeles";
}

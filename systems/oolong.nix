{ inputs, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../disko/oolong.nix
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/plymouth.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];
        loader.grub.gfxmodeEfi = "1366x768";
    };

    environment.systemPackages = with pkgs; [ file-roller ];

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;

    programs = {
        dconf.enable = true;
        thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
                thunar-archive-plugin
                thunar-media-tags-plugin
                thunar-volman
                tumbler
            ];
        };
    };

    time.timeZone = "America/Los_Angeles";

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

        gvfs.enable = true;
        libinput.touchpad.scrollMethod = "twofinger";
        libinput.touchpad.accelSpeed = "-0.5";
        thermald.enable = true;
        tumbler.enable = true;

    };

    nix = {
        buildMachines = [ {
            hostName = "magrathea";
            system = "x86_64-linux";
            protocol = "ssh-ng";
            maxJobs = 4;
            speedFactor = 999;
            supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        } ];
        distributedBuilds = true;
        settings.builders-use-substitutes = true;
    };

    programs.ssh.extraConfig = ''
        Host magrathea
            HostName magrathea
            User nixremote
            IdentitiesOnly yes
            IdentityFile /root/.ssh/nixremote
    '';

}

{ pkgs, ... }: {

    imports = [
        ../disko/hofud.nix
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/nextcloud-desktop.nix
        ../programs/openscad.nix
        ../programs/wezterm.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
        initrd.kernelModules = [];
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];
        loader.grub.gfxmodeEfi = "1366x768";
    };

    hardware = {
        cpu.amd.updateMicrocode = true;
        enableAllFirmware = true;
        enableRedistributableFirmware = true;
    };
    nixpkgs.config.allowUnfree = true;
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
        libinput.touchpad.scrollMethod = "twofinger";
        libinput.touchpad.accelSpeed = "-0.5";
        thermald.enable = true;
    };

}

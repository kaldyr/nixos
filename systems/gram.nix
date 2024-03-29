{ config, lib, pkgs, sysConfig, ... }: {

    imports = [
        ./disko/gram.nix
        ./modules/desktop.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ]; # Fill out when installing
            kernelModules = [ ];
        };

        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];

        loader = {

            efi.efiSysMountPoint = "/boot";

            grub = {
                enable = true;
                device = "nodev";
                efiInstallAsRemovable = true;
                efiSupport = true;
                gfxmodeEfi = "1366x768";
                theme = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "grub";
                    rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
                    sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
                } + "/src/catppuccin-frappe-grub-theme";
                useOSProber = false;
            };

        };

    };

    environment.systemPackages = with pkgs; [ tailscale ];

    hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableRedistributableFirmware = true;
        enableAllFirmware = true;
    };

    networking.hostName = "hofud";
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

        fwupd.enable = true;
        tailscale.enable = true;
        thermald.enable = true;

        xserver = {
            videoDrivers = [ "amdgpu" ];
            libinput = {
                enable = true;
                touchpad.scrollMethod = "twofinger";
                touchpad.accelSpeed = "-0.5";
            };
        };

    };

}

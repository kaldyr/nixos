{ config, lib, pkgs, sysConfig, ... }: {

    imports = [
        ./default.nix
        ./disko/espresso.nix
        ./modules/desktop.nix
        ./modules/budgie.nix
        ./modules/programs/plymouth.nix
        ./modules/programs/steam.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
            kernelModules = [ "amdgpu" ];
        };

        kernelModules = [ "kvm-amd" "amd-pstate" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "amd-pstate=guided" "btrfs" "initcall_blacklist=acpi_cpufreq_init" "quiet" ];

        loader = {

            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };

            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                gfxmodeEfi = "1920x1080";
                theme = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "grub";
                    rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
                    sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
                } + "/src/catppuccin-frappe-grub-theme";
            };

        };

    };

    hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableRedistributableFirmware = true;
        enableAllFirmware = true;
    };

    nixpkgs.config.allowUnfree = true;
    networking.hostName = sysConfig.hostname;
    time.timeZone = "America/Los_Angeles";

    services = {
        fwupd.enable = true;
        xserver.videoDrivers = [ "amdgpu" ];
        xserver.libinput.enable = true;
    };

}

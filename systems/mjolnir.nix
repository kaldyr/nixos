{ config, lib, pkgs, sysConfig, ... }: {

    imports = [
        ./default.nix
        # ./disko/mjolnir.nix
        ./modules/desktop.nix
        ./modules/programs/plymouth.nix
        ./modules/programs/steam.nix
    ];

    boot = {

        extraModprobeConfig = ''
            options iwlwifi bt_coex_active=0
        '';

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = [ "nvme" "xhci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
            kernelModules = [ "amdgpu" ];
        };

        kernelModules = [ "kvm-amd" "amd-pstate" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "amd-pstate=guided" "btrfs" "initcall_blacklist=acpi_cpufreq_init" "quiet" ];

        loader = {

            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/grub/efi";
            };

            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                gfxmodeEfi = "3440x1440,1920x1080";
                theme = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "grub";
                    rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
                    sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
                } + "/src/catppuccin-frappe-grub-theme";
                useOSProber = true;
            };

        };

        supportedFilesystems = [ "ntfs" ];

    };

    environment.systemPackages = with pkgs; [ tailscale ];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/3091f642-88da-43ed-9cb8-0ae191b9b534";
            fsType = "btrfs";
            options = [ "noatime" "ssd" "discard" "compress-force=zstd:1" "space_cache=v2" ];
        };
        "/boot/grub/efi" = {
            device = "/dev/disk/by-uuid/BD34-641A";
            fsType = "vfat";
        };
        "/windows" = {
            device = "/dev/disk/by-uuid/D2D4EB7BD4EB5FE9";
            fsType = "ntfs-3g";
            options = [ "rw" "uid=1000" "gid=100" ];
        };
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/0ae7a9ac-72e8-4491-9391-cc9104c73ddd"; } ];

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
        tailscale.enable = true;
        xserver = {
            videoDrivers = [ "amdgpu" ];
            libinput.enable = true;
        };
    };

}

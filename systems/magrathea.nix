{ config, lib, pkgs, ... }: {

    imports = [
        ./disko/magrathea.nix
        ./modules/kodi.nix
        # ./containers/nextcloud.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
            kernelModules = [ "i915" ];
        };

        kernelModules = [ ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" ];

        loader = {

            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
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
                useOSProber = false;
            };

        };

    };

    environment.systemPackages = with pkgs; [ tailscale ];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/84f4315e-e003-4269-8565-bfbac7cf2c06";
            fsType = "btrfs";
            options = [ "subvol=root" "ssd" "compress-force=zstd:3" "space_cache=v2" ];
        };
        "/boot/efi" = { # Change to UUID
            device = "/dev/disk/by-label/BOOTEFI";
            fsType = "vfat";
        };
        "/var/lib/nextcloud" = {
            device = "/dev/disk/by-uuid/84f4315e-e003-4269-8565-bfbac7cf2c06";
            fsType = "btrfs";
            options = [ "subvol=nextcloud" "ssd" "compress-force=zstd:3" "space_cache=v2" ];
        };
        # Create a new subvolume for mysql
        # "/var/lib/mysql" = {
        #   device = "/dev/disk/by-uuid/84f4315e-e003-4269-8565-bfbac7cf2c06";
        #   fsType = "btrfs";
        #   options = [ "subvol=mysql" "ssd" "compress-force=zstd:3" "space_cache=v2" ];
        # };
        # Create raid volume
        # "/storage" = {
        #    device = "/dev/disk/by-uuid/";
        #    fsType = "btrfs";
        #    options = [ ];
        #  };
    };

    swapDevices = [ { # Change to UUID
        device = "/dev/disk/by-label/NIXSWAP"; }
    ];

    hardware = {
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableRedistributableFirmware = true;
        enableAllFirmware = true;
    };

    nixpkgs.config.allowUnfree = true;
    networking.hostName = "magrathea";
    time.timeZone = "America/Los_Angeles";

    services = {
        fwupd.enable = true;
        tailscale.enable = true;
        xserver = {
            videoDrivers = [ "i915" ];
            libinput.enable = true;
        };
    };

}

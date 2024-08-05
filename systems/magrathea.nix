{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../programs/kodi.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
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
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    networking.hostName = sysConfig.hostname;
    time.timeZone = "America/Los_Angeles";

    services = {
        fwupd.enable = true;
        libinput.enable = true;
        tailscale.enable = true;
    };

}

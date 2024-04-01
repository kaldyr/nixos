{ config, lib, pkgs, sysConfig, ... }: {

    imports = [
        ./default.nix
        ../disko/serenity.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = []; # Fill out from generated hardware-configuration.nix when installing
            kernelModules = [ "amdgpu" ];
        };

        kernelModules = [ ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];

        loader = {

            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };

            grub = {
                enable = true;

                device = "nodev";
                efiSupport = true;
                gfxmodeEfi = "3840x2160";
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
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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

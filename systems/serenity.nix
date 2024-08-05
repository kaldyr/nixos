{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        ../programs/kodi.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = []; # Fill out from generated hardware-configuration.nix when installing
        initrd.kernelModules = [ "amdgpu" ];
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];

        loader = {

            efi.canTouchEfiVariables = true;
            efi.efiSysMountPoint = "/boot";

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

{ lib, inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
        inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        ../disko/mjolnir.nix
        ./desktop.nix
        ../services/openrazer.nix
        ../programs/hyprland.nix
        ../programs/librewolf.nix
        ../programs/lutris.nix
        ../programs/nextcloud-desktop.nix
        ../programs/openscad.nix
        ../programs/plymouth.nix
        ../programs/retroarch.nix
        ../programs/steam.nix
        ../services/epson-et-8550.nix
        ../services/keyd.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
        initrd.kernelModules = [ "amdgpu" ];
        kernel.sysctl."vm.max_map_count" = 16777216;
        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" "preempt=full" ];
        loader.grub.gfxmodeEfi = "3440x1440,1920x1080";
    };

    environment.systemPackages = with pkgs; [
        android-tools
        quickemu
        quickgui
        virglrenderer
    ];

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ "Machines" ];
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

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;

    # networking = {
    #     bridges."br0".interfaces = [ "enp1s0" ];
    #     interfaces."br0".ipv4.addresses = [{
    #         address = "10.0.0.231";
    #         prefixLength = 24;
    #     }];
    #     defaultGateway = "10.0.0.1";
    #     nameservers = [ "10.0.0.1" "9.9.9.9" ];
    # };

	services.keyd.keyboards.default.settings.main.esc = "`";

    time.timeZone = "America/Los_Angeles";

    # virtualisation.libvirtd = {
    #     enable = true;
    #     allowedBridges = [ "br0" ];
    # };


}

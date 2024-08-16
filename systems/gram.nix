{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
        ./desktop.nix
        ../programs/hyprland.nix
        ../programs/mpd.nix
        ../programs/plymouth.nix
        ../programs/steam.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ]; # Fill out when installing
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];
        loader.grub.gfxmodeEfi = "2256x1504";
    };

    disko.devices.disk.main = {

        device = "/dev/disk/by-id/nvme-CT500P3PSSD8_240746F1F0AC";
        type = "disk";

        content = {

            type = "gpt";

            partitions = {

                ESP = {

                    name = "ESP";
                    type = "EF00";
                    start = "1MiB";
                    size = "512M"; # Change to 2G next install

                    content = {
                        type = "filesystem";
                        format = "vfat";
                        extraArgs = [ "-F" "32" ];
                        mountpoint = "/boot";
                        mountOptions = [ "defaults" ];
                    };

                };

                luks = {

                    size = "100%";

                    content = {

                        type = "luks";
                        name = "crypted";
                        settings.allowDiscards = true;

                        content = {

                            type = "btrfs";

                            extraArgs = [ "-f" ];

                            # btrfs subvolumes must all have the same mount options for now.
                            subvolumes = let
                                driveOptions = [ "noatime" "discard=async" "compress-force=zstd:1" ];
                            in {
                                # SSH subvolume.  Race condition when symlinking and/or persisting with sops-nix
                                "@etc_ssh" = { mountpoint = "/etc/ssh"; mountOptions = driveOptions; };
                                # Files to be preserved between boots that can be regenerated easily
                                "@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
                                # Files to be preserved between boots and be backed up to restore machine state
                                "@state" = { mountpoint = "/state"; mountOptions = driveOptions; };
                                # Snapshot storage
                                "@snaps" = { mountpoint = "/snaps"; mountOptions = driveOptions; };
                                # Swapfile
                                "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "8G"; };
                            };

                        };

                    };

                };

            };

        };

    };

    fileSystems = {

        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=8G" "mode=755" ];
        };

        "/etc/ssh".neededForBoot = true;

        "/home" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=256M" "mode=755" ];
        };

        "/nix".neededForBoot = true;
        "/state".neededForBoot = true;

    };

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    networking.hostName = sysConfig.hostname;
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

        libinput = {
            enable = true;
            touchpad.scrollMethod = "twofinger";
            touchpad.accelSpeed = "-0.5";
        };

        tailscale.enable = true;
        thermald.enable = true;

    };

}

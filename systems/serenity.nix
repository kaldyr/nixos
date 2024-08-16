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
        loader.grub.gfxmodeEfi = "3840x2160";
    };

    # Manual interventions required!!!
    # Disko cannot apply chattr settings
    # Disko cannot yet handle multiple device btrfs
    # The storage array should not be managed by Disko to preserve data
    disko.devices.disk.main = {

        device = "";
        type = "disk";

        content = {

            type = "gpt";

            partitions = {

                ESP = {

                    name = "ESP";
                    type = "EF00";
                    start = "1MiB";
                    size = "2G";

                    content = {
                        type = "filesystem";
                        format = "vfat";
                        extraArgs = [ "-F" "32" ];
                        mountpoint = "/boot";
                        mountOptions = [ "defaults" ];
                    };

                };

                main = {

                    size = "100%";

                    content = {

                        type = "btrfs";
                        extraArgs = [ "-f" ];

                        subvolumes = let
                            # btrfs subvolumes must all have the same mount options for now.
                            driveOptions = [ "noatime" "discard=async" "compress-force=zstd:3" ];
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

    fileSystems = {

        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=2G" "mode=755" ];
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

        # To manually create the raid array:
        #    mkfs.btrfs -m raid1 -d raid1 /dev/sdY /dev/sdZ
        #    mkdir -p /storage
        #    mount /dev/sdW /storage
        #    cd /storage
        #    btrfs subvolume create @media
        #    btrfs subvolume create @snaps
        #    cd ..
        #    umount /storage

        "/storage/media" = {
            device = ""; # Put the uuid of one of the disks in the array
            fsType = "btrfs";
            options = [ "subvol=@media" "noatime" "compress-force=zstd:8" ];
        };

        "/storage/snaps" = {
            device = ""; # Put the uuid of one of the disks in the array
            fsType = "btrfs";
            options = [ "subvol=@snaps" "noatime" "compress-force=zstd:8" ];
        };

    };

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

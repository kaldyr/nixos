{ inputs, pkgs, sysConfig, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../programs/kodi.nix
        ../programs/nextcloud-server.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" ];
        loader.grub.gfxmodeEfi = "1920x1080";
    };

    # Manual interventions required!!!
    # Disko cannot yet handle multiple device btrfs
    # The storage array should not be managed by Disko to preserve data
    disko.devices.disk.main = {

        device = "/dev/disk/by-id/wwn-0x500a0751e6e1bdd7";
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
                            "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "16G"; };
                            # Syncthing storage
                            "@sync" = { mountpoint = "/sync"; mountOptions = driveOptions; };

                            # Subvolumes for managing nextcloud
                            # Nextcloud - schedule snapshots
                            "@nextcloud" = { mountpoint = "/var/lib/nextcloud"; mountOptions = driveOptions; };
                            # Mysql
                            # Databases should not be stored with CoW property
                            # This will disable CoW, checksums, and compression for the database
                            # Do not snapshot this subvolume!
                            # After Disko does its thing, and before installing nixos, run the following:
                            #   chattr +C /var/lib.postgresql
                            "@mysql" = { mountpoint = "/var/lib/postgresql"; mountOptions = driveOptions; };  

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
        #    mkfs.btrfs -m raid10 -d raid10 /dev/sdW /dev/sdX /dev/sdY /dev/sdZ
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

{ ... }: {
# Manual interventions required!!!
# Disko cannot yet handle multiple device btrfs
# The storage array should not be managed by Disko to preserve data
# Read the comments in this file.

    # disko.devices.disk.main = {
    #
    #     device = "";
    #     type = "disk";
    #
    #     content = {
    #
    #         type = "gpt";
    #
    #         partitions = {
    #
    #             ESP = {
    #                 name = "ESP";
    #                 type = "EF00";
    #                 start = "1MiB";
    #                 size = "512M";
    #                 content = {
    #                     type = "filesystem";
    #                     format = "vfat";
    #                     extraArgs = [ "-F" "32" ];
    #                     mountpoint = "/boot";
    #                     mountOptions = [ "defaults" ];
    #                 };
    #             };
    #
    #             main = {
    #                 size = "100%";
    #                 content = {
    #                     type = "btrfs";
    #                     extraArgs = [ "-f" ];
    #                     subvolumes = let
    #                         # btrfs subvolumes must all have the same mount options for now.
    #                         driveOptions = [ "noatime" "discard=async" "compress-force=zstd:3" ];
    #                     in {
    #                         # SSH subvolume.  Race condition when symlinking and/or persisting with sops-nix
    #                         "@etc_ssh" = { mountpoint = "/etc/ssh"; mountOptions = driveOptions; };
    #                         # Files to be preserved between boots that can be regenerated easily
    #                         "@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
    #                         # Files to be preserved between boots and be backed up to restore machine state
    #                         "@state" = { mountpoint = "/state"; mountOptions = driveOptions; };
    #                         # Snapshot storage
    #                         "@snaps" = { mountpoint = "/snaps"; mountOptions = driveOptions; };
    #                         # Swapfile
    #                         "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "8G"; };
    #                         # Syncthing storage
    #                         "@sync" = { mountpoint = "/sync"; mountOptions = driveOptions; };
    #
    #
    #                         # Subvolumes for managing nextcloud
    #                         # Nextcloud - schedule snapshots
    #                         "@nextcloud" = { mountpoint = "/srv/nextcloud"; mountOptions = driveOptions; };
    #                         # Mysql
    #                         # Databases should not be stored with CoW property
    #                         # This will disable CoW, checksums, and compression for the database
    #                         # Do not snapshot this subvolume!
    #                         # Instead, setup cron job to mysqldump to @nextcloud for snapshots
    #                         # For restoration, first restore @nextcloud from snapshot, then source the most recent backup.dump
    #                         # After Disko does its thing, and before installing nixos, run the following:
    #                         #   chattr +C /srv/nextcloud/mysql
    #                         "@mysql" = { mountpoint = "/srv/nextcloud/mysql"; mountOptions = driveOptions; };  
    #                     };
    #                 };
    #             };
    #
    #         };
    #
    #     };
    #
    # };
    #
    # fileSystems = {
    #
    #     "/" = {
    #         device = "none";
    #         fsType = "tmpfs";
    #         neededForBoot = true;
    #         options = [ "defaults" "size=1G" "mode=755" ];
    #     };
    #
    #     "/etc/ssh".neededForBoot = true;
    #
    #     "/home" = {
    #         device = "none";
    #         fsType = "tmpfs";
    #         neededForBoot = true;
    #         options = [ "defaults" "size=256M" "mode=755" ];
    #     };
    #
    #     "/nix".neededForBoot = true;
    #     "/state".neededForBoot = true;
    #
    #     # To manually create the raid array:
    #     #    mkfs.btrfs -m raid10 -d raid10 /dev/sdW /dev/sdX /dev/sdY /dev/sdZ
    #     #    mkdir -p /storage
    #     #    mount /dev/sdW /storage
    #     #    cd /storage
    #     #    btrfs subvolume create @media
    #     #    btrfs subvolume create @snaps
    #     #    cd ..
    #     #    umount /storage
    #
    #     "/storage/media" = {
    #         device = ""; # Put the uuid of one of the disks in the array
    #         fsType = "btrfs";
    #         options = [ "subvol=@media" "noatime" "compress-force=zstd:8" ];
    #     };
    #
    #     "/storage/snaps" = {
    #         device = ""; # Put the uuid of one of the disks in the array
    #         fsType = "btrfs";
    #         options = [ "subvol=@snaps" "noatime" "compress-force=zstd:8" ];
    #     };
    #
    # };
    
    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/84f4315e-e003-4269-8565-bfbac7cf2c06";
            fsType = "btrfs";
            options = [ "subvol=root" "ssd" "compress-force=zstd:3" "space_cache=v2" ];
        };
        "/boot/efi" = {
            device = "/dev/disk/by-label/BOOTEFI";
            fsType = "vfat";
        };
        "/var/lib/nextcloud" = {
            device = "/dev/disk/by-uuid/84f4315e-e003-4269-8565-bfbac7cf2c06";
            fsType = "btrfs";
            options = [ "subvol=nextcloud" "ssd" "compress-force=zstd:3" "space_cache=v2" ];
        };
    };

    swapDevices = [ {
        device = "/dev/disk/by-label/NIXSWAP"; }
    ];

}

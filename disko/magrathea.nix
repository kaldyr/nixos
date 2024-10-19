{

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

                            # Mysql
                            # Databases should not be stored with CoW property
                            # This will disable CoW, checksums, and compression for the database
                            # Do not snapshot this subvolume!
                            # After Disko does its thing, and before installing nixos, run the following:
                            #   chattr +C /var/lib.postgresql
                            "@mysql" = { mountpoint = "/var/lib/postgresql"; mountOptions = driveOptions; };  
                            # FIXME: Change name from @mysql to @sql next install

                        };

                    };

                };

            };

        };

    };

}

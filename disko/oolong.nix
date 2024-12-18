{

    disko.devices.disk.main = {

        device = "/dev/disk/by-id/ata-Dell_WR202KD032G_E70290F5_P02702KD2G1042b8e66b";
        type = "disk";

        content = {

            type = "gpt";

            partitions = {

                ESP = {

                    name = "ESP";
                    type = "EF00";
                    start = "1MiB";
                    size = "1G";

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
                                # Root
                                "@root" = { mountpoint = "/"; mountOptions = driveOptions; };
                                # Swapfile
                                "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "4G"; };
                            };
                        };

                    };

                };

            };

        };

    };

}

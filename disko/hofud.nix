{

    disko.devices.disk.main = {

        device = "/dev/disk/by-id/ata-Dell_WR202KD032G_E70290F5_P02702KD2G10432a11e1";
        type = "disk";

        content = {

            type = "gpt";

            partitions.ESP = {
                name = "ESP";
                type = "EF00";
                start = "1MiB";
                size = "768M";
                content = {
                    type = "filesystem";
                    format = "vfat";
                    extraArgs = [ "-F" "32" ];
                    mountpoint = "/boot";
                    mountOptions = [ "defaults" ];
                };
            };

            partitions.luks = {
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
                            "@root" = { mountpoint = "/"; mountOptions = driveOptions; };
                            "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "1G"; };
                        };
                    };
                };
            };

        };

    };

}

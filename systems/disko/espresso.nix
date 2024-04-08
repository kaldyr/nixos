{ ... }: {

    disko.devices.disk.main = {

        device = "/dev/disk/by-id/nvme-SPCC_M.2_PCIe_SSD_230165515150004";
        type = "disk";

        content = {

            type = "gpt";

            partitions = {

                ESP = {
                    name = "ESP";
                    type = "EF00";
                    start = "1MiB";
                    size = "256M";
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
                            subvolumes =
                            let
                                driveOptions = [ "noatime" "discard=async" "compress-force=zstd:1" ];
                            in {
                                # SSH subvolume. Race condition when symlinking and/or persisting with sops-nix
                                "@etc_ssh" = { mountpoint = "/etc/ssh"; mountOptions = driveOptions; };
                                # Home folder. Keeping everything for now.
                                "@home" = { mountpoint = "/home"; mountOptions = driveOptions; };
                                # Files to be preserved between boots
                                "@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
                                # Snapshot storage
                                "@snaps" = { mountpoint = "/snaps"; mountOptions = driveOptions; };
                                # Swapfile
                                "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "512M"; };
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
            options = [ "defaults" "size=2G" "mode=755" ];
        };
        "/etc/ssh".neededForBoot = true;
        "/home".neededForBoot = true;
        "/nix".neededForBoot = true;
    };

}

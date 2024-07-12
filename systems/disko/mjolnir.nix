{ ... }: {

    disko.devices.disk.main = {

        device = "/dev/disk/by-id/nvme-SOLIDIGM_SSDPFKKW020X7_SSC1N514010901I6Z";
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
            options = [ "defaults" "size=6G" "mode=755" ];
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

}

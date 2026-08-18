{
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
          size = "2G";

          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = [
              "-F"
              "32"
            ];
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
                  driveOptions = [
                    "noatime"
                    "discard=async"
                    "compress-force=zstd:1"
                  ];
                in
                {
                  "@home" = { mountpoint = "/home"; mountOptions = driveOptions; };
                  "@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
                  "@state" = { mountpoint = "/state"; mountOptions = driveOptions; };
                  "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "8G"; };
                };
            };
          };
        };
      };
    };
  };
}

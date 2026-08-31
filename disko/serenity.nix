{
  # Manual interventions required!!!
  # Disko cannot yet handle multiple device btrfs
  # The storage array should not be managed by Disko to preserve data
  disko.devices.disk.main = {

    device = "/dev/disk/by-id/ata-KINGSTON_SA400S37120G_50026B76832D3433";
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

        main = {
          size = "100%";

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];

            subvolumes =
              let
                # btrfs subvolumes must all have the same mount options for now.
                driveOptions = [
                  "noatime"
                  "discard=async"
                  "compress-force=zstd:3"
                ];
              in
              {
                "@data" = { mountpoint = "/data"; mountOptions = driveOptions; };
                "@home" = { mountpoint = "/home"; mountOptions = driveOptions; };
                "@nix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
                "@state" = { mountpoint = "/state"; mountOptions = driveOptions; };
                "@swap" = { mountpoint = "/swap"; swap.swapfile.size = "16G"; };
              };
          };
        };
      };
    };
  };
}

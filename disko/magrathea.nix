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

                # Postgres
                # Databases should not be stored with CoW property
                # This will disable CoW, checksums, and compression for the database
                # Do not snapshot this subvolume!
                # After Disko does its thing, and before installing nixos, run the following:
                #   chattr +C /var/lib/postgresql
                "@postgres" = { mountpoint = "/var/lib/postgresql"; mountOptions = driveOptions; };
              };
          };
        };
      };
    };
  };
}

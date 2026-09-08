{
  disko.devices.disk."flash" = {

    device = "/dev/disk/by-id/usb-Samsung_Flash_Drive_FIT_0321821050004118-0:0";
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
            name = "usbcrypted";
            settings = {
              allowDiscards = true;

              crypttabExtraOpts = [
                "discard"
                "no-read-workqueue"
                "no-write-workqueue"
              ];
            };

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              # btrfs subvolumes must all have the same mount options for now.
              subvolumes =
                let
                  driveOptions = [
                    "noatime"
                    "discard=async"
                    "compress=zstd:3"
                  ];
                in
                {
                  "@usbnix" = { mountpoint = "/nix"; mountOptions = driveOptions; };
                  "@usbstate" = { mountpoint = "/state"; mountOptions = driveOptions; };
                  "@usbstorage" = { mountpoint = "/storage"; mountOptions = driveOptions; };
                };
            };
          };
        };
      };
    };
  };
}

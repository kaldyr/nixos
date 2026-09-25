{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings = {
    devices = {
      aziraphale.id = "FIP6JCJ-QMZ353Y-WIRJPKA-5S45S2S-GUZLT6X-EUJOSHT-DMSH6JF-W3FQCQ2";
      espresso.id = "GHB4M4V-LTDEJAT-K7RSH6B-J356MLT-OSIULSB-D5PVJAD-4K4EZUL-BHWBLAS";
      gungnir.id = "VLGBL5L-XAFQV3N-GHOFDLI-ZRC6BYT-C5LHRDR-DO4RF46-4TE6ILP-I32OHAT";
      installer.id = "EKEB4HK-5OVXUSI-WIYH3H3-EYCZUN5-FHU6X7V-LLNSNJB-QXCU7T5-LVT4VQK";
      magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      mjolnir.id = "2OH2UKZ-YUQIZKC-R3R3KUY-B3T7XDQ-4BPLA2J-LDV5YR4-S3SGBZA-CZ237AZ";
      normandy.id = "KWLWGBN-F3DJXKP-DRYQ7D3-WP4PNDA-LTRHUOU-KDTSF4V-2QFENXE-BK3AQAU";
      serenity.id = "YBFZRRR-7SVPJLB-CQ74YJK-WSAF62W-2IXVUY5-4GHHA77-5HPCM4B-GRHXQQJ";
    };

    folders = {
      janice-browser = {
        path = "/data/sync/janice/Browser";
        devices = [ "aziraphale" "serenity" ];
      };

      janice-documents = {
        path = "/data/sync/janice/Documents";
        devices = [ "aziraphale" "serenity" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      janice-passwords = {
        path = "/data/sync/janice/Passwords";
        devices = [ "aziraphale" "serenity" ];
      };

      matshkas-browser = {
        path = "/data/sync/matshkas/Browser";
        devices = [ "espresso" ];
      };

      matshkas-documents = {
        path = "/data/sync/matshkas/Documents";
        devices = [ "espresso" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matshkas-guildwars2 = {
        path = "/data/sync/matshkas/GuildWars2";
        devices = [ "espresso" ];
      };

      matshkas-notes = {
        path = "/data/sync/matshkas/Notes";
        devices = [ "espresso" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matshkas-passwords = {
        path = "/data/sync/matshkas/Passwords";
        devices = [ "espresso" ];
      };

      matt-browser = {
        path = "/data/sync/matt/Browser";
        devices = [ "mjolnir" ];
      };

      matt-documents = {
        path = "/data/sync/matt/Documents";
        devices = [ "mjolnir" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matt-guildwars2 = {
        path = "/data/sync/matt/GuildWars2";
        devices = [ "mjolnir" ];
      };

      matt-notes = {
        path = "/data/sync/matt/Notes";
        devices = [ "gungnir" "mjolnir" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matt-openstarbound = {
        path = "/data/sync/matt/Openstarbound";
        devices = [ "mjolnir" ];
      };

      matt-passwords = {
        path = "/data/sync/matt/Passwords";
        devices = [ "gungnir" "installer" "mjolnir" ];
      };

      nic-browser = {
        path = "/data/sync/nic/Browser";
        devices = [ "normandy" ];
      };

      nic-documents = {
        path = "/data/sync/nic/Documents";
        devices = [ "normandy" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      nic-enshrouded = {
        path = "/data/sync/nic/Enshrouded";
        devices = [ "normandy" ];
      };

      nic-notes = {
        path = "/data/sync/nic/Notes";
        devices = [ "normandy" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      nic-openstarbound = {
        path = "/data/sync/nic/Openstarbound";
        devices = [ "normandy" ];
      };

      shared-roms = {
        path = "/storage/media/Roms";
        devices = [ "mjolnir" ];
        type = "sendonly";
      };

      shared-videos-offline = {
        path = "/storage/media/Videos/Offline";
        devices = [ "gungnir" ];
        type = "sendonly";
      };
    };

    gui.insecureSkipHostcheck = true;
  };

  users.users.syncthing.extraGroups = [ "media" ];
}

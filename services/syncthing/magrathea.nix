{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings = {
    devices = {
      amyrose.id = "FAYMIWZ-TIPKLPB-NKORNPA-DD6AIS3-KC2TOU2-PUVGNH4-ONGKP25-BZAG5QR";
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

      kaylee-browser = {
        path = "/data/sync/kaylee/Browser";
        devices = [ "amyrose" ];
      };

      kaylee-documents = {
        path = "/data/sync/kaylee/Documents";
        devices = [ "amyrose" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      kaylee-guildwars2 = {
        path = "/data/sync/kaylee/GuildWars2";
        devices = [ "amyrose" ];
      };

      kaylee-notes = {
        path = "/data/sync/kaylee/Notes";
        devices = [ "amyrose" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      kaylee-openstarbound = {
        path = "/data/sync/kaylee/Openstarbound";
        devices = [ "amyrose" ];
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

      matt-phone = {
        path = "/data/sync/matt/Phone";
        devices = [ "gungnir" ];
      };

      matt-phone-settings = {
        path = "/data/sync/matt/PhoneSettings";
        devices = [ "gungnir" ];
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

      nic-guildwars2 = {
        path = "/data/sync/nic/GuildWars2";
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

      nix-config = {
        path = "/nix/config";

        devices = [
          "amyrose"
          "aziraphale"
          "espresso"
          "installer"
          "magrathea"
          "mjolnir"
          "normandy"
          "serenity"
        ];

        ignorePerms = true;
      };

      shared-guildwars2-pathing = {
        path = "/data/sync/shared/GuildWars2";

        devices = [
          "espresso"
          "mjolnir"
          "normandy"
        ];
      };

      shared-videos-offline = {
        path = "/storage/media/Videos/Offline";
        devices = [ "gungnir" ];
      };
    };

    gui.insecureSkipHostcheck = true;
  };

  systemd.tmpfiles.rules = [
    # User janice
    "d /data/sync/janice 2775 syncthing syncthing -"
    # Sync Folder janice-browser
    "d /data/sync/janice/Browser 2775 syncthing syncthing -"
    # Sync Folder janice-documents
    "d /data/sync/janice/Documents 2775 syncthing syncthing -"
    # Sync Folder janice-passwords
    "d /data/sync/janice/Passwords 2775 syncthing syncthing -"

    # User matshkas
    "d /data/sync/matshkas 2775 syncthing syncthing -"
    # Sync Folder matshkas-browser
    "d /data/sync/matshkas/Browser 2775 syncthing syncthing -"
    # Sync Folder matshkas-documents
    "d /data/sync/matshkas/Documents 2775 syncthing syncthing -"
    # Sync Folder matshkas-guildwars2
    "d /data/sync/matshkas/GuildWars2 2775 syncthing syncthing -"
    # Sync Folder matshkas-notes
    "d /data/sync/matshkas/Notes 2775 syncthing syncthing -"
    # Sync Folder matshkas-passwords
    "d /data/sync/matshkas/Passwords 2775 syncthing syncthing -"

    # User matt
    "d /data/sync/matt 2775 syncthing syncthing -"
    # Sync Folder matt-browser
    "d /data/sync/matt/Browser 2775 syncthing syncthing -"
    # Sync Folder matt-documents
    "d /data/sync/matt/Documents 2775 syncthing syncthing -"
    # Sync Folder matt-guildwars2
    "d /data/sync/matt/GuildWars2 2775 syncthing syncthing -"
    # Sync Folder matt-notes
    "d /data/sync/matt/Notes 2775 syncthing syncthing -"
    # Sync Folder matt-openstarbound
    "d /data/sync/matt/Openstarbound 2775 syncthing syncthing -"
    # Sync Folder matt-passwords
    "d /data/sync/matt/Passwords 2775 syncthing syncthing -"
    # Sync Folder matt-phone
    "d /data/sync/matt/Phone 2775 syncthing syncthing -"
    # Sync Folder matt-phone-settings
    "d /data/sync/matt/PhoneSettings 2775 syncthing syncthing -"

    # User nic
    "d /data/sync/nic 2775 syncthing syncthing -"
    # Sync Folder nic-browser
    "d /data/sync/nic/Browser 2775 syncthing syncthing -"
    # Sync Folder nic-documents
    "d /data/sync/nic/Documents 2775 syncthing syncthing -"
    # Sync Folder nic-enshrouded
    "d /data/sync/nic/Enshrouded 2775 syncthing syncthing -"
    # Sync Folder nic-guildwars2
    "d /data/sync/nic/GuildWars2 2775 syncthing syncthing -"
    # Sync Folder nic-notes
    "d /data/sync/nic/Notes 2775 syncthing syncthing -"
    # Sync Folder nic-openstarbound
    "d /data/sync/nic/Openstarbound 2775 syncthing syncthing -"

    # Shared Folders
    "d /data/sync/shared 2775 syncthing syncthing -"
    # Sync Folder shared-guildwars2-pathing
    "d /data/sync/shared/GuildWars2 2775 syncthing syncthing -"
  ];

  users = {
    groups.syncthing = {};

    users.syncthing = {
      group = "syncthing";
      isSystemUser = true;

      extraGroups = [
        "media"
        "nixconfig"
      ];
    };
  };
}

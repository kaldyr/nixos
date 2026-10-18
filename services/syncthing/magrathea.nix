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
        ignorePerms = true;
      };

      janice-documents = {
        path = "/data/sync/janice/Documents";
        devices = [ "aziraphale" "serenity" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      janice-phone-camera = {
        path = "/data/sync/janice/Phone";
        devices = [ "aziraphale" "serenity" ];
        ignorePerms = true;
      };

      janice-windows = {
        path = "/data/sync/janice/Windows";
        devices = [ "aziraphale" "serenity" ];
        ignorePerms = true;
      };

      kaylee-browser = {
        path = "/data/sync/kaylee/Browser";
        devices = [ "amyrose" ];
        ignorePerms = true;
      };

      kaylee-documents = {
        path = "/data/sync/kaylee/Documents";
        devices = [ "amyrose" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      kaylee-guildwars2 = {
        path = "/data/sync/kaylee/GuildWars2";
        devices = [ "amyrose" ];
        ignorePerms = true;
      };

      kaylee-notes = {
        path = "/data/sync/kaylee/Notes";
        devices = [ "amyrose" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      kaylee-openstarbound = {
        path = "/data/sync/kaylee/Openstarbound";
        devices = [ "amyrose" ];
        ignorePerms = true;
      };

      matshkas-browser = {
        path = "/data/sync/matshkas/Browser";
        devices = [ "espresso" ];
        ignorePerms = true;
      };

      matshkas-documents = {
        path = "/data/sync/matshkas/Documents";
        devices = [ "espresso" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matshkas-guildwars2 = {
        path = "/data/sync/matshkas/GuildWars2";
        devices = [ "espresso" ];
        ignorePerms = true;
      };

      matshkas-notes = {
        path = "/data/sync/matshkas/Notes";
        devices = [ "espresso" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matt-browser = {
        path = "/data/sync/matt/Browser";
        devices = [ "mjolnir" ];
        ignorePerms = true;
      };

      matt-documents = {
        path = "/data/sync/matt/Documents";
        devices = [ "mjolnir" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matt-guildwars2 = {
        path = "/data/sync/matt/GuildWars2";
        devices = [ "mjolnir" ];
        ignorePerms = true;
      };

      matt-notes = {
        path = "/data/sync/matt/Notes";
        devices = [ "gungnir" "mjolnir" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      matt-openstarbound = {
        path = "/data/sync/matt/Openstarbound";
        devices = [ "mjolnir" ];
        ignorePerms = true;
      };

      matt-phone = {
        path = "/data/sync/matt/Phone";
        devices = [ "gungnir" ];
        ignorePerms = true;
      };

      matt-phone-settings = {
        path = "/data/sync/matt/PhoneSettings";
        devices = [ "gungnir" ];
        ignorePerms = true;
      };

      nic-browser = {
        path = "/data/sync/nic/Browser";
        devices = [ "normandy" ];
        ignorePerms = true;
      };

      nic-documents = {
        path = "/data/sync/nic/Documents";
        devices = [ "normandy" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      nic-enshrouded = {
        path = "/data/sync/nic/Enshrouded";
        devices = [ "normandy" ];
        ignorePerms = true;
      };

      nic-guildwars2 = {
        path = "/data/sync/nic/GuildWars2";
        devices = [ "normandy" ];
        ignorePerms = true;
      };

      nic-notes = {
        path = "/data/sync/nic/Notes";
        devices = [ "normandy" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      nic-openstarbound = {
        path = "/data/sync/nic/Openstarbound";
        devices = [ "normandy" ];
        ignorePerms = true;
      };

      nix-config = {
        path = "/nix/config";

        devices = [
          "amyrose"
          "aziraphale"
          "espresso"
          "installer"
          "mjolnir"
          "normandy"
          "serenity"
        ];

        ignorePatterns = [
          "/programs/yazi/config/plugins"
          "/programs/quickshell/config/.qmlls.ini"
        ];

        ignorePerms = true;
      };

      shared-guildwars2-pathing = {
        path = "/data/sync/shared/GuildWars2";

        devices = [
          "amyrose"
          "espresso"
          "mjolnir"
          "normandy"
        ];

        ignorePerms = true;
      };

      shared-passwords = {
        path = "/data/sync/shared/Passwords";

        devices = [
          "amyrose"
          "aziraphale"
          "gungnir"
          "espresso"
          "installer"
          "mjolnir"
          "normandy"
          "serenity"
        ];

        ignorePerms = true;
      };
    };

    gui.insecureSkipHostcheck = true;
  };

  systemd.tmpfiles.rules = [
    "d /data/sync/janice 2775 syncthing syncthing -"
    "d /data/sync/kaylee 2775 syncthing syncthing -"
    "d /data/sync/matshkas 2775 syncthing syncthing -"
    "d /data/sync/matt 2775 syncthing syncthing -"
    "d /data/sync/nic 2775 syncthing syncthing -"
    "d /data/sync/shared 2775 syncthing syncthing -"
  ];

  users = {
    groups.syncthing = {};

    users.syncthing = {
      group = "syncthing";
      isSystemUser = true;
      extraGroups = [ "media" "nixconfig" ];
    };
  };
}

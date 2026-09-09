{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings.folders = {
    matt-browser = {
      path = "/data/sync/matt/Browser";
      devices = [ "mjolnir" ];
    };

    matt-documents = {
      path = "/data/sync/matt/Documents";
      devices = [ "mjolnir" ];

      versioning = {
        type = "staggered";

        params = {
          cleanInterval = "3600";
          maxAge = "604800"; # 7 days
        };
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
        type = "staggered";

        params = {
          cleanInterval = "3600";
          maxAge = "604800"; # 7 days
        };
      };
    };

    matt-openstarbound = {
      path = "/data/sync/matt/Openstarbound";
      devices = [ "mjolnir" ];
    };

    matt-passwords = {
      path = "/data/sync/matt/Passwords";
      devices = [ "gungnir" "mjolnir" ];
    };

    shared-music = {
      path = "/storage/media/Music";
      devices = [ "mjolnir" ];
      type = "sendonly";
    };

    shared-roms = {
      path = "/storage/media/Roms";
      devices = [ "mjolnir" ];
      type = "sendonly";
    };
  };

  systemd.tmpfiles.rules = [ "d /data/sync - syncthing syncthing 0755 -" ];

  users.users.syncthing.extraGroups = [ "media" ];
}

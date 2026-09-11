{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing.settings = {
    gui.insecureSkipHostcheck = true;

    folders = {
      # matshkas-browser = {
      #   path = "/data/sync/matshkas/Browser";
      #   devices = [ "espresso" ];
      # };
      #
      # matshkas-documents = {
      #   path = "/data/sync/matshkas/Documents";
      #   devices = [ "espresso" ];
      #
      #   versioning = {
      #     type = "simple";
      #     params.keep = "10";
      #   };
      # };
      #
      # matshkas-guildwars2 = {
      #   path = "/data/sync/matshkas/GuildWars2";
      #   devices = [ "espresso" ];
      # };
      #
      # matshkas-notes = {
      #   path = "/data/sync/matshkas/Notes";
      #   devices = [ "espresso" ];
      #
      #   versioning = {
      #     type = "simple";
      #     params.keep = "10";
      #   };
      # };
      #
      # matshkas-passwords = {
      #   path = "/data/sync/matshkas/Passwords";
      #   devices = [ "espresso" ];
      # };

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

      # nic-browser = {
      #   path = "/data/sync/nic/Browser";
      #   devices = [ "normandy" ];
      # };
      #
      # nic-documents = {
      #   path = "/data/sync/nic/Documents";
      #   devices = [ "normandy" ];
      #
      #   versioning = {
      #     type = "simple";
      #     params.keep = "10";
      #   };
      # };
      #
      # nic-notes = {
      #   path = "/data/sync/nic/Notes";
      #   devices = [ "normandy" ];
      #
      #   versioning = {
      #     type = "simple";
      #     params.keep = "10";
      #   };
      # };
      #
      # nic-openstarbound = {
      #   path = "/home/nic/.local/state/openstarbound/storage";
      #   devices = [ "normandy" ];
      # };

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
  };

  users.users.syncthing.extraGroups = [ "media" ];
}

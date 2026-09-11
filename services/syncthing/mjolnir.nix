{
  config,
  ...
}:
{
  services.syncthing = {
    user = "matt";
    group = "users";
    configDir = "/home/matt/.config/syncthing";
    databaseDir = "/home/matt/.local/state/syncthing";

    settings.folders = {
      matt-browser = {
        path = "/home/matt/.config/net.imput.helium";
        devices = [ "magrathea" ];
      };

      matt-documents = {
        path = "/home/matt/Documents";
        devices = [ "magrathea" ];
      };

      matt-guildwars2 = {
        path = "/home/matt/.wine/guild-wars-2/drive_c/Program Files/Guild Wars 2/addons";
        devices = [ "magrathea" ];
      };

      matt-notes = {
        path = "/home/matt/Vaults/Notes";
        devices = [ "gungnir" "magrathea" ];
      };

      matt-openstarbound = {
        path = "/home/matt/.local/state/openstarbound/storage";
        devices = [ "magrathea" ];
      };

      matt-passwords = {
        path = "/home/matt/.passwords";
        devices = [ "gungnir" "installer" "magrathea" ];
      };

      shared-music = {
        path = "/home/matt/Music";
        devices = [ "magrathea" ];
        type = "receiveonly";
      };

      shared-roms = {
        path = "/home/matt/Roms";
        devices = [ "magrathea" ];
        type = "receiveonly";
      };
    };
  };

  sops.secrets = {
    "syncthing/mjolnir/music-stignore" = {
      owner = "matt";
      group = "users";
      mode = "0400";
    };

    "syncthing/mjolnir/roms-stignore" = {
      owner = "matt";
      group = "users";
      mode = "0400";
    };
  };

  systemd = {
    services = {
      syncthing-stignore-files = {
        before = [ "syncthing.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          install -D -o matt -g users -m 0400 \
            ${config.sops.secrets."syncthing/mjolnir/music-stignore".path} \
            /home/matt/Music/.stignore
          chown matt:users /home/matt/Music

          install -D -o matt -g users -m 0400 \
            ${config.sops.secrets."syncthing/mjolnir/roms-stignore".path} \
            /home/matt/Roms/.stignore
          chown matt:users /home/matt/Roms
        '';
      };

      syncthing = {
        wants = [ "syncthing-stignore-files.service" ];
        after = [ "syncthing-stignore-files.service" ];
      };
    };
  };
}

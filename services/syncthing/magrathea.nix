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
      type = "receiveonly";
    };

    matt-documents = {
      path = "/data/sync/matt/Documents";
      devices = [ "mjolnir" ];
      type = "receiveonly";
    };

    matt-guildwars2 = {
      path = "/data/sync/matt/GuildWars2";
      devices = [ "mjolnir" ];
      type = "receiveonly";
    };

    matt-notes = {
      path = "/data/sync/matt/Notes";
      devices = [ "gungnir" "mjolnir" ];
      type = "receiveonly";
    };

    matt-openstarbound = {
      path = "/data/sync/matt/Openstarbound";
      devices = [ "mjolnir" ];
      type = "receiveonly";
    };

    matt-passwords = {
      path = "/data/sync/matt/Passwords";
      devices = [ "gungnir" "mjolnir" ];
      type = "receiveonly";
    };
  };

  systemd.tmpfiles.rules = [ "d /data/sync - syncthing syncthing 0755 -" ];
}

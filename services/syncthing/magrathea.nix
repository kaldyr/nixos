{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings.folders = {
    matt-notes = {
      path = "/data/sync/matt/Notes";
      type = "receiveonly";
      devices = [ "gungnir" "mjolnir" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/sync - syncthing syncthing 0755 -"
  ];
}

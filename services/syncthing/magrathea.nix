{
  services.syncthing.settings.folders = {
    matt-notes = {
      path = "/data/sync/matt/Notes";
      type = "receiveonly";
      devices = [ "gungnir" "mjolnir" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/sync - syncthing syncthing 0755 -"
    "d /data/sync/matt - syncthing syncthing 0755 -"
    "d /data/sync/matt/Notes - syncthing syncthing 0755 -"
  ];
}

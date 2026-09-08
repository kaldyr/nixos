{
  services.syncthing.settings.folders = {
    matt-notes = {
      path = "/data/matt/Notes";
      type = "receiveonly";
      devices = [ "gungnir" "mjolnir" ];
    };
  };
}

{
  services.syncthing = {
    user = "matt";
    group = "users";
    configDir = "/home/matt/.config/syncthing";
    dataDir = "/home/matt/.local/state/syncthing";

    settings.folders = {
      matt-notes = {
        path = "/home/matt/Notes";
        devices = [ "gungnir" "magrathea" ];
      };
    };
  };
}

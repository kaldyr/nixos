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

      matt-notes = {
        path = "/home/matt/Notes";
        devices = [ "gungnir" "magrathea" ];
      };

      matt-openstarbound = {
        path = "/home/matt/.local/state/openstarbound/storage";
        devices = [ "magrathea" ];
      };

      matt-passwords = {
        path = "/home/matt/.passwords";
        devices = [ "gungnir" "magrathea" ];
      };
    };
  };
}

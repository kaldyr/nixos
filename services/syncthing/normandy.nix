{
  services.syncthing = {
    user = "nic";
    group = "users";
    configDir = "/home/nic/.config/syncthing";
    databaseDir = "/home/nic/.local/state/syncthing";

    settings.folders = {
      nic-browser = {
        path = "/home/nic/.config/net.imput.helium";
        devices = [ "magrathea" ];
      };

      nic-documents = {
        path = "/home/nic/Documents";
        devices = [ "magrathea" ];
      };

      nic-notes = {
        path = "/home/nic/Vaults/Notes";
        devices = [ "magrathea" ];
      };

      nic-openstarbound = {
        path = "/home/nic/.local/state/openstarbound/storage";
        devices = [ "magrathea" ];
      };
    };
  };
}

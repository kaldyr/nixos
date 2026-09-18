{
  services.syncthing = {
    user = "nic";
    group = "users";
    configDir = "/home/nic/.config/syncthing";
    databaseDir = "/home/nic/.local/state/syncthing";

    settings = {
      devices = {
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      };

      folders = {
        nic-browser = {
          path = "/home/nic/.config/net.imput.helium";
          devices = [ "magrathea" ];
        };

        nic-documents = {
          path = "/home/nic/Documents";
          devices = [ "magrathea" ];
        };

        nic-enshrouded = {
          path = "/home/nic/.local/share/Steam/steamapps/compatdata/1203620/pfx/drive_c/users/steamuser/Saved Games/Enshrouded";
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
  };
}

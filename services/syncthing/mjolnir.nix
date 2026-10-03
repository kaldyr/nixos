{
  services.syncthing = {
    user = "matt";
    group = "users";
    configDir = "/home/matt/.config/syncthing";
    databaseDir = "/home/matt/.local/state/syncthing";

    settings = {
      devices = {
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      };

      folders = {
        matt-browser = {
          path = "/home/matt/.config/net.imput.helium";
          devices = [ "magrathea" ];
        };

        matt-documents = {
          path = "/home/matt/Documents";
          devices = [ "magrathea" ];
        };

        matt-guildwars2 = {
          path = "/state/guildwars2/addons";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/Taimi/pathing" ];
        };

        matt-notes = {
          path = "/home/matt/Vaults/Notes";
          devices = [ "magrathea" ];
        };

        matt-openstarbound = {
          path = "/home/matt/.local/state/openstarbound/storage";
          devices = [ "magrathea" ];
        };

        matt-passwords = {
          path = "/home/matt/.passwords";
          devices = [ "magrathea" ];
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/.git" ];
          ignorePerms = true;
        };

        shared-guildwars2-pathing = {
          path = "/state/guildwars2/pathing";
          devices = [ "magrathea" ];
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    # .config
    "d /home/matt/.config 0755 matt users -"
    # Syncthing home
    "d /home/matt/.config/syncthing 0755 matt users -"
    # Sync Folder: matt-browser
    "d /home/matt/.config/net.imput.helium 0755 matt users -"
    # Sync Folder: matt-documents
    "d /home/matt/Documents 0755 matt users -"
    # guildwars2
    "d /state/guildwars2 0755 matt users -"
    # Sync Folder: matt-guildwars2
    "d /state/guildwars2/addons 0755 matt users -"
    # Sync Folder: shared-guildwars2-pathing
    "d /state/guildwars2/pathing 0755 matt users -"
    # Sync Folder: matt-notes
    "d /home/matt/Vaults/Notes 0755 matt users -"
    # Sync Folder: matt-openstarbound
    "d /home/matt/.local 0755 matt users -"
    "d /home/matt/.local/state 0755 matt users -"
    "d /home/matt/.local/state/openstarbound 0755 matt users -"
    "d /home/matt/.local/state/openstarbound/storage 0755 matt users -"
    # Sync Folder: matt-passwords
    "d /home/matt/.passwords 0700 matt users -"
  ];
}

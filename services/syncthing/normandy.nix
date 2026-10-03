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
          # path = "/state/enshrouded";
          path = "/home/nic/.local/share/Steam/steamapps/compatdata/1203620/pfx/drive_c/users/steamuser/Saved Games/Enshrouded";
          devices = [ "magrathea" ];
        };

        nic-guildwars2 = {
          path = "/state/guildwars2/addons";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/Taimi/pathing" ];
        };

        nic-notes = {
          path = "/home/nic/Vaults/Notes";
          devices = [ "magrathea" ];
        };

        nic-openstarbound = {
          path = "/home/nic/.local/state/openstarbound/storage";
          devices = [ "magrathea" ];
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" ];
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
    "d /home/nic/.config 0755 nic users -"
    # Syncthing home
    "d /home/nic/.config/syncthing 0755 nic users -"
    # Sync Folder: nic-browser
    "d /home/nic/.config/net.imput.helium 0755 nic users -"
    # Sync Folder: nic-documents
    "d /home/nic/Documents 0755 nic users -"
    # Sync Folder: nic-enshrouded
    "d /state/enshrouded 0755 nic users -"
    # guildwars2
    "d /state/guildwars2 0755 nic users -"
    # Sync Folder: nic-guildwars2
    "d /state/guildwars2/addons 0755 nic users -"
    # Sync Folder: shared-guildwars2-pathing
    "d /state/guildwars2/pathing 0755 nic users -"
    # Sync Folder: nic-notes
    "d /home/nic/Vaults/Notes 0755 nic users -"
    # Sync Folder: nic-openstarbound
    "d /home/nic/.local 0755 nic users -"
    "d /home/nic/.local/state 0755 nic users -"
    "d /home/nic/.local/state/openstarbound 0755 nic users -"
    "d /home/nic/.local/state/openstarbound/storage 0755 nic users -"
    # Sync Folder: nic-passwords
    "d /home/nic/.passwords 0700 nic users -"
  ];
}

{
  services.syncthing = {
    user = "matshkas";
    group = "users";
    configDir = "/home/matshkas/.config/syncthing";
    databaseDir = "/home/matshkas/.local/state/syncthing";

    settings = {
      devices = {
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      };

      folders = {
        matshkas-browser = {
          path = "/home/matshkas/.config/net.imput.helium";
          devices = [ "magrathea" ];
        };

        matshkas-documents = {
          path = "/home/matshkas/Documents";
          devices = [ "magrathea" ];
        };

        matshkas-guildwars2 = {
          path = "/state/guildwars2/addons";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/Taimi/pathing" ];
        };

        matshkas-notes = {
          path = "/home/matshkas/Vaults/Notes";
          devices = [ "magrathea" ];
        };

        matshkas-passwords = {
          path = "/home/matshkas/.passwords";
          devices = [ "magrathea" ];
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" ];

          ignorePatterns = [
            "/programs/yazi/config/plugins"
            "/programs/quickshell/config/.qmlls.ini"
          ];

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
    "d /home/matshkas/.config 0755 matshkas users -"
    # Syncthing home
    "d /home/matshkas/.config/syncthing 0755 matshkas users -"
    # Sync Folder: matshkas-browser
    "d /home/matshkas/.config/net.imput.helium 0755 matshkas users -"
    # Sync Folder: matshkas-documents
    "d /home/matshkas/Documents 0755 matshkas users -"
    # guildwars2
    "d /state/guildwars2 0755 matshkas users -"
    # Sync Folder: matshkas-guildwars2
    "d /state/guildwars2/addons 0755 matshkas users -"
    # Sync Folder: shared-guildwars2-pathing
    "d /state/guildwars2/pathing 0755 matshkas users -"
    # Sync Folder: matshkas-notes
    "d /home/matshkas/Vaults/Notes 0755 matshkas users -"
    # Sync Folder: matshkas-passwords
    "d /home/matshkas/.passwords 0700 matshkas users -"
  ];
}

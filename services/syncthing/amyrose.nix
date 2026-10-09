{
  services.syncthing = {
    user = "kaylee";
    group = "users";
    configDir = "/home/kaylee/.config/syncthing";
    databaseDir = "/home/kaylee/.local/state/syncthing";

    settings = {
      devices = {
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      };

      folders = {
        kaylee-browser = {
          path = "/home/kaylee/.config/net.imput.helium";
          devices = [ "magrathea" ];
        };

        kaylee-documents = {
          path = "/home/kaylee/Documents";
          devices = [ "magrathea" ];
        };

        kaylee-guildwars2 = {
          path = "/state/guildwars2/addons";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/Taimi/pathing" ];
        };

        kaylee-notes = {
          path = "/home/kaylee/Vaults/Notes";
          devices = [ "magrathea" ];
        };

        kaylee-openstarbound = {
          path = "/home/kaylee/.local/state/openstarbound/storage";
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
    "d /home/kaylee/.config 0755 kaylee users -"
    # Syncthing home
    "d /home/kaylee/.config/syncthing 0755 kaylee users -"
    # Sync Folder: kaylee-browser
    "d /home/kaylee/.config/net.imput.helium 0755 kaylee users -"
    # Sync Folder: kaylee-documents
    "d /home/kaylee/Documents 0755 kaylee users -"
    # guildwars2
    "d /state/guildwars2 0755 kaylee users -"
    # Sync Folder: kaylee-guildwars2
    "d /state/guildwars2/addons 0755 kaylee users -"
    # Sync Folder: shared-guildwars2-pathing
    "d /state/guildwars2/pathing 0755 kaylee users -"
    # Sync Folder: kaylee-notes
    "d /home/kaylee/Vaults/Notes 0755 kaylee users -"
    # Sync Folder: kaylee-openstarbound
    "d /home/kaylee/.local 0755 kaylee users -"
    "d /home/kaylee/.local/state 0755 kaylee users -"
    "d /home/kaylee/.local/state/openstarbound 0755 kaylee users -"
    "d /home/kaylee/.local/state/openstarbound/storage 0755 kaylee users -"
    # Sync Folder: kaylee-passwords
    "d /home/kaylee/.passwords 0700 kaylee users -"
  ];
}

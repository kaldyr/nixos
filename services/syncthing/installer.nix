{
  home-manager.users.matt.home.persistence."/state".directories = [
    ".config/syncthing"
    ".local/state/syncthing"
  ];

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
        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" ];

          ignorePatterns = [
            "/programs/yazi/config/plugins"
            "/programs/quickshell/config/.qmlls.ini"
          ];

          ignorePerms = true;
        };

        shared-passwords = {
          path = "/state/passwords";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /state/passwords 0755 matt users -"
  ];
}

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
        matt-passwords = {
          path = "/home/matt/.passwords";
          devices = [ "magrathea" ];
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };
      };
    };
  };
}

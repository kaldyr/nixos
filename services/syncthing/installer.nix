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

    settings.folders.matt-passwords = {
      path = "/home/matt/.passwords";
      devices = [ "gungnir" "installer" "magrathea" ];
    };
  };
}

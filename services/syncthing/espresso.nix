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
          path = "/home/matshkas/.wine/guild-wars-2/drive_c/Program Files/Guild Wars 2/addons";
          devices = [ "magrathea" ];
        };

        matshkas-notes = {
          path = "/home/matshkas/Vaults/Notes";
          devices = [ "magrathea" ];
        };

        matshkas-passwords = {
          path = "/home/matshkas/.passwords";
          devices = [ "magrathea" ];
        };
      };
    };
  };
}

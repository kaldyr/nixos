{
  services.syncthing = {
    user = "matt";
    group = "users";
    configDir = "/home/matt/.config/syncthing";
    databaseDir = "/home/matt/.local/state/syncthing";

    settings = {
      devices = {
        gungnir.id = "VLGBL5L-XAFQV3N-GHOFDLI-ZRC6BYT-C5LHRDR-DO4RF46-4TE6ILP-I32OHAT";
        installer.id = "EKEB4HK-5OVXUSI-WIYH3H3-EYCZUN5-FHU6X7V-LLNSNJB-QXCU7T5-LVT4VQK";
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
          path = "/home/matt/.wine/guild-wars-2/drive_c/Program Files/Guild Wars 2/addons";
          devices = [ "magrathea" ];
        };

        matt-notes = {
          path = "/home/matt/Vaults/Notes";
          devices = [ "gungnir" "magrathea" ];
        };

        matt-openstarbound = {
          path = "/home/matt/.local/state/openstarbound/storage";
          devices = [ "magrathea" ];
        };

        matt-passwords = {
          path = "/home/matt/.passwords";
          devices = [ "gungnir" "installer" "magrathea" ];
        };

        shared-roms = {
          path = "/home/matt/Roms";
          devices = [ "magrathea" ];
          type = "receiveonly";
        };
      };
    };
  };
}

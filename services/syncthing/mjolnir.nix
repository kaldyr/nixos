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
        serenity.id = "YBFZRRR-7SVPJLB-CQ74YJK-WSAF62W-2IXVUY5-4GHHA77-5HPCM4B-GRHXQQJ";
      };

      folders = {
        matt-browser = {
          path = "/home/matt/.config/net.imput.helium";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };

        matt-documents = {
          path = "/home/matt/Documents";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };

        matt-guildwars2 = {
          path = "/state/guildwars2/addons";
          devices = [ "magrathea" ];
          ignorePatterns = [ "/Taimi/pathing" ];
          ignorePerms = true;
        };

        matt-notes = {
          path = "/home/matt/Vaults/Notes";
          devices = [ "gungnir" "magrathea" ];
          ignorePerms = true;
        };

        matt-openstarbound = {
          path = "/home/matt/.local/state/openstarbound/storage";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "installer" "magrathea" "serenity" ];

          ignorePatterns = [
            "/.git"
            "/programs/yazi/config/plugins"
          ];

          ignorePerms = true;
        };

        shared-guildwars2-pathing = {
          path = "/state/guildwars2/pathing";
          devices = [ "magrathea" ];
          ignorePerms = true;
        };

        shared-passwords = {
          path = "/state/passwords";
          devices = [ "gungnir" "installer" "magrathea" ];
          ignorePerms = true;
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
    # Sync Folder: shared-passwords
    "d /state/passwords 0755 matt users -"
  ];
}

{
  services.syncthing = {
    user = "janice";
    group = "users";
    configDir = "/home/janice/.config/syncthing";
    databaseDir = "/home/janice/.local/state/syncthing";

    settings = {
      devices = {
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
        serenity.id = "YBFZRRR-7SVPJLB-CQ74YJK-WSAF62W-2IXVUY5-4GHHA77-5HPCM4B-GRHXQQJ";
      };

      folders = {
        janice-browser = {
          path = "/home/janice/.config/net.imput.helium";
          devices = [ "magrathea" "serenity" ];
        };

        janice-documents = {
          path = "/home/janice/Documents";
          devices = [ "magrathea" "serenity" ];
        };

        janice-passwords = {
          path = "/home/janice/.passwords";
          devices = [ "magrathea" "serenity" ];
        };

        nix-config = {
          path = "/nix/config";
          devices = [ "magrathea" "serenity" ];

          ignorePatterns = [
            "/programs/yazi/config/plugins"
            "/programs/quickshell/config/.qmlls.ini"
          ];

          ignorePerms = true;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    # .config
    "d /home/janice/.config 0755 janice users -"
    # Syncthing home
    "d /home/janice/.config/syncthing 0755 janice users -"
    # Sync Folder: janice-browser
    "d /home/janice/.config/net.imput.helium 0755 janice users -"
    # Sync Folder: janice-documents
    "d /home/janice/Documents 0755 janice users -"
    # Sync Folder: janice-passwords
    "d /home/janice/.passwords 0700 janice users -"
  ];
}

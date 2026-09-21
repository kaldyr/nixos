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
          devices = [ "magrathea" ];
        };

        janice-documents = {
          path = "/home/janice/Documents";
          devices = [ "magrathea" ];
        };

        janice-passwords = {
          path = "/home/matt/.passwords";
          devices = [ "gungnir" "installer" "magrathea" ];
        };
      };
    };
  };
}

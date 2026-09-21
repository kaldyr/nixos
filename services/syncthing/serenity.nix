{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings = {
    devices = {
      aziraphale.id = "FIP6JCJ-QMZ353Y-WIRJPKA-5S45S2S-GUZLT6X-EUJOSHT-DMSH6JF-W3FQCQ2";
      magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
    };

    folders = {
      janice-browser = {
        path = "/data/sync/janice/Browser";
        devices = [ "aziraphale" "serenity" ];
      };

      janice-documents = {
        path = "/data/sync/janice/Documents";
        devices = [ "aziraphale" "serenity" ];

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      janice-passwords = {
        path = "/data/sync/janice/Passwords";
        devices = [ "aziraphale" "serenity" ];
      };
    };

    gui.insecureSkipHostcheck = true;
  };

  users.users.syncthing.extraGroups = [ "media" ];
}

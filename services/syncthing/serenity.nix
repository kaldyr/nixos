{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings = {
    devices = {
      atuin.id = "WEI7LC7-7CKQPUW-NYVAJHX-A4V5VKG-ECLJQRM-IHKXGU2-7CADOAJ-T4J3PAS";
      aziraphale.id = "FIP6JCJ-QMZ353Y-WIRJPKA-5S45S2S-GUZLT6X-EUJOSHT-DMSH6JF-W3FQCQ2";
      crowley.id = "SL5HLQF-CLGSSSY-LBWNU6R-3CL55XD-A7QAZSW-MWWRDR2-3LRXSHF-GXL6IQT";
      magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
    };

    folders = {
      janice-browser = {
        path = "/data/sync/janice/Browser";
        devices = [ "aziraphale" "magrathea" ];
        ignorePerms = true;
      };

      janice-documents = {
        path = "/data/sync/janice/Documents";
        devices = [ "aziraphale" "magrathea" ];
        ignorePerms = true;

        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };

      janice-phone-camera = {
        path = "/data/sync/janice/Phone";
        devices = [ "atuin" "aziraphale" "crowley" "magrathea" ];
        ignorePerms = true;
      };

      janice-windows = {
        path = "/data/sync/janice/Windows";
        devices = [ "aziraphale" "crowley" "magrathea" ];
        ignorePerms = true;
      };

      nix-config = {
        path = "/nix/config";
        devices = [ "aziraphale" "magrathea" ];

        ignorePatterns = [
          "/programs/yazi/config/plugins"
          "/programs/quickshell/config/.qmlls.ini"
        ];

        ignorePerms = true;
      };

      shared-passwords = {
        path = "/data/sync/shared/Passwords";
        devices = [ "magrathea" ];
        ignorePerms = true;
      };
    };

    gui.insecureSkipHostcheck = true;
  };

  systemd.tmpfiles.rules = [
    "d /data/sync/janice 2775 syncthing syncthing -"
    "d /data/sync/kaylee 2775 syncthing syncthing -"
    "d /data/sync/matshkas 2775 syncthing syncthing -"
    "d /data/sync/matt 2775 syncthing syncthing -"
    "d /data/sync/nic 2775 syncthing syncthing -"
    "d /data/sync/shared 2775 syncthing syncthing -"
  ];

  users = {
    groups.syncthing = {};

    users.syncthing = {
      group = "syncthing";
      isSystemUser = true;
      extraGroups = [ "media" "nixconfig" ];
    };
  };
}

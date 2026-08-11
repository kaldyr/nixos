{ config, ... }: {
  imports = [ ../postgresql ];

  environment.persistence."/state/system".directories = [
    {
      directory = "/var/lib/linkwarden";
      user = "linkwarden";
      group = "linkwarden";
      mode = "0750";
    }
  ];

  services = {
    linkwarden = {
      enable = true;

      database = {
        host = "/run/postgresql";
        name = "linkwarden";
        user = "linkwarden";
        createLocally = true;
      };

      environment.NEXTAUTH_SECRET = config.sops.secrets.linkwarden-nextauth-secret.path;

      enableRegistration = true;
      user = "linkwarden";
      group = "linkwarden";

      host = "magrathea.brill-godzilla.ts.net";
      port = 9002;
      openFirewall = true;

      secretFiles.NEXTAUTH_SECRET = config.sops.secrets.linkwarden-nextauth-secret.path;
      storageLocation = "/var/lib/linkwarden";
    };

    postgresql.ensureDatabases = [ "linkwarden" ];
    postgresql.ensureUsers = [ {
      name = "linkwarden";
      ensureDBOwnership = true;
    } ];

    postgresqlBackup.databases = [ "linkwarden" ];
  };

  sops.secrets.linkwarden-nextauth-secret = {
    owner = "linkwarden";
    group = "linkwarden";
    mode = "0400";
  };

  systemd.services.linkwarden = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  users.extraUsers."linkwarden" = {
    extraGroups = [ "webservice" ];
    group = "linkwarden";
    home = "/var/lib/linkwarden";
    isSystemUser = true;
  };

  users.groups."linkwarden" = { };
}

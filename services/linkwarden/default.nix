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
        host = "localhost";
        name = "linkwarden";
        user = "linkwarden";
        createLocally = true;
      };

      environment = {
        DATABASE_URL = "postgresql://linkwarden@localhost:5432/linkwarden";
        NEXTAUTH_SECRET = config.sops.secrets.linkwarden-nextauth-secret.path;
        NEXTAUTH_URL = "http://localhost:9002/api/v1/auth";
      };

      enableRegistration = true;
      user = "linkwarden";
      group = "linkwarden";

      port = 9002;
      openFirewall = true;

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

  users.extraUsers."linkwarden" = {
    extraGroups = [ "webservice" ];
    group = "linkwarden";
    home = "/var/lib/linkwarden";
    isSystemUser = true;
  };

  users.groups."linkwarden" = { };
}

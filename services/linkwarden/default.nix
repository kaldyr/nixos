{
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

  users.extraUsers."linkwarden" = {
    extraGroups = [ "webservice" ];
    group = "linkwarden";
    home = "/var/lib/linkwarden";
    isSystemUser = true;
  };

  users.groups."linkwarden" = { };
}

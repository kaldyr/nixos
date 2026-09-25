{
  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/vikunja";
      user = "vikunja";
      group = "vikunja";
      mode = "0750";
    }
  ];

  services = {
    postgresql = {
      ensureDatabases = [ "vikunja" ];

      ensureUsers = [
        {
          name = "vikunja";
          ensureDBOwnership = true;
        }
      ];
    };

    postgresqlBackup.databases = [ "vikunja" ];

    vikunja = {
      enable = true;

      address = "127.0.0.1";
      port = 3456;
      frontendScheme = "https";
      frontendHostname = "tasks.brill-godzilla.ts.net";

      database = {
        type = "postgres";
        host = "/run/postgresql";
        user = "vikunja";
        database = "vikunja";
      };

      settings.database.sslmode = "disable";
    };
  };

  users = {
    groups.vikunja = { };

    users.vikunja = {
      isSystemUser = true;
      group = "vikunja";
    };
  };
}

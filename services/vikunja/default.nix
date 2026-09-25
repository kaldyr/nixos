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

      frontendScheme = "https";
      frontendHostname = "tasks.brill-godzilla.ts.net";

      settings = {
        service = {
          interface = "127.0.0.1:3456";
          publicurl = "https://tasks.brill-godzilla.ts.net/";
        };

        database = {
          type = "postgres";
          host = "/run/postgresql";
          user = "vikunja";
          database = "vikunja";
          sslmode = "disable";
        };
      };
    };
  };
}

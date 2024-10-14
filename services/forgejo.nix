{ ... }: {

    imports = [ ./postgresql.nix ];

    environment.persistence."/state/system".directories = [
        {
            directory = "/var/lib/forgejo";
            user = "forgejo";
            group = "forgejo";
            mode = "0700";
        }
    ];

    networking.firewall.allowedTCPPorts = [ 9090 ];
    networking.firewall.allowedUDPPorts = [ 9090 ];

    services = {

        forgejo = {

            enable = true;

            user = "forgejo";
            group = "forgejo";
            stateDir = "/var/lib/forgejo";

            database = {
                createDatabase = true;
                name = "forgejo";
                type = "postgres";
                user = "forgejo";
            };

            dump.enable = false;
            lfs.enable = true;

            settings = {

                DEFAULT.APP_NAME = "Project Forge";

                log.LEVEL = "Warn";

                repository.ENABLE_PUSH_CREATE_USER = true;
                repository.DEFAULT_BRANCH = "main";

                server = {
                    DOMAIN = "magrathea";
                    HTTP_ADDR = "0.0.0.0";
                    HTTP_PORT = 9090;
                    ROOT_URL = "http://magrathea:9090";
                };

                service.DISABLE_REGISTRATION = true; # Comment out for initial install
                session.COOKIE_SECURE = false; # Only accessible through tailnet

            };

            useWizard = false;

        };

        postgresql.ensureDatabases = [ "forgejo" ];
        postgresql.ensureUsers = [ { name = "forgejo"; ensureDBOwnership = true; } ];
        postgresqlBackup.databases = [ "forgejo" ];

    };

    users.extraUsers."forgejo" = {
        group = "forgejo";
        home = "/var/lib/forgejo";
        isSystemUser = true;
    };

}

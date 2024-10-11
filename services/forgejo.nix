{ ... }: {

    persistence."/state/system".directories = [
        { directory = "/var/lib/forgejo"; mode = "0700"; }
    ];

    services = {

        forgejo = {

            enable = true;

            user = "forgejo";
            group = "forgejo";
            stateDir = "/var/lib/forgejo";

            database = {
                name = "forgejo";
                type = "postgres";
                user = "forgejo";
            };

            dump.enable = false;

            lfs.enable = true;

            settings = {

                DEFAULT.APP_NAME = "Personal Forge";

                log.LEVEL = "Warn";

                repository.ENABLE_PUSH_CREATE_USER = true;
                repository.DEFAULT_BRANCH = "main";

                server = {
                    DOMAIN = "git.magrathea.brill-godzilla.ts.net";
                    ROOT_URL = "https://git.magrathea.brill-godzilla.ts.net";
                    HTTP_ADDR = "127.0.0.1";
                    HTTP_PORT = 9090;
                };

                # Comment out for initial install
                service.DISABLE_REGISTRATION = true;

                session.COOKIE_SECURE = true;

            };

        };

        postgresql.ensureDatabases = [ "forgejo" ];
        postgresql.ensureUsers = [ "forgejo" ];
        postgresqlBackup.databases = [ "forgejo" ];

    };

}

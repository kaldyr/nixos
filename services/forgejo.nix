{ ... }: {

    imports = [ ./postgresql.nix ];

    environment.persistence."/state/system".directories = [
        { directory = "/var/lib/forgejo"; mode = "0700"; }
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
                    DOMAIN = "git.magrathea.brill-godzilla.ts.net";
                    ROOT_URL = "https://git.magrathea.brill-godzilla.ts.net";
                    HTTP_ADDR = "127.0.0.1";
                    HTTP_PORT = 9090;
                };

                service.DISABLE_REGISTRATION = true; # Comment out for initial install
                session.COOKIE_SECURE = true;

            };

            useWizard = false;

        };

        nginx.virtualHosts."localhost" = {
            forceSSL = false;
            listen = [ { addr = "127.0.0.1"; port = 9090; } ];
            sslCertificate = "/var/lib/tailscale/certs/magrathea.brill-godzilla.ts.net.crt";
            sslCertificateKey = "/var/lib/tailscale/certs/magrathea.brill-godzilla.ts.net.key";
        };

        postgresql.ensureDatabases = [ "forgejo" ];
        postgresql.ensureUsers = [ { name = "forgejo"; ensureDBOwnership = true; } ];
        postgresqlBackup.databases = [ "forgejo" ];

    };

    users.extraUsers."forgejo" = {
        description = "Forgejo Service";
        group = "forgejo";
        home = "/var/lib/forgejo";
        isSystemUser = true;
    };

}

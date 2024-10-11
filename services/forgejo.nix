{ ... }: {

    persistence."/state/system".directories = [
        { directory = "/var/lib/forgejo"; mode = "0700"; }
    ];

    services = {

        forgejo = {
            enable = true;
        };

        postgresql.ensureDatabases = [ "forgejo" ];
        postgresql.ensureUsers = [ "forgejo" ];
        postgresqlBackup.databases = [ "forgejo" ];

    };

}

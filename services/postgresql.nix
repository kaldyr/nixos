{ pkgs, ... }: {

    services = {

        postgresql = {
            enable = true;
            package = pkgs.postgresql_16;
            settings.max_connections = "300";
            settings.shared_buffers = "80MB";
        };

        postgresqlBackup = {
            enable = true;
            location = "/state/system/dbbackup";
            startAt = "*-*-* 01:15:00";
        };

    };

    users = {

        extraUsers."postgres" = {
            group = "postgres";
            home = "/var/lib/postgresql/16";
            isSystemUser = true;
        };

        groups.postgres = {};

    };

}

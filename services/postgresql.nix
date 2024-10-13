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
            extraGroups = [ "nextcloud" ]; # FIXME: remove next install subvol -> state
            group = "postgres";
            home = "/var/lib/posgresql";
            isSystemUser = true;
        };

        groups.postgres = {};

    };

}

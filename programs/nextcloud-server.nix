{ config, pkgs, ... }: {

    networking.firewall.allowedTCPPorts = [ 9000 ];
    networking.firewall.allowedUDPPorts = [ 9000 ];

    services = {

        nextcloud = {

            enable = true;
            package = pkgs.nextcloud29;

            appstoreEnable = true;
            autoUpdateApps.enable = true;
            caching.apcu = true;

            config = {
                adminpassFile = config.sops.secrets.nextcloud-admin.path;
                adminuser = "admin";
                dbhost = "/run/postgresql";
                dbname = "nextcloud";
                dbtype = "pgsql";
                dbuser = "nextcloud";
                defaultPhoneRegion = "US";
                trustedProxies = "";
            };

            database.createLocally = true;
            enableImagemagick = false;

            extraApps = with config.services.nextcloud.package.packages.apps; {

                inherit calendar contacts mail news notes onlyoffice tasks;

                socialsharing_telegram = pkgs.fetchNextcloudApp {
                    url = "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.1.0/socialsharing_telegram-v3.1.0.tar.gz";
                    license = "agpl3";
                    sha256 = "";
                };

            };

            extraAppsEnable = true;
            extraOptions.mail_sendmailmode = "pipe";
            extraOptions.mail_smtpmode = "sendmail";
            hostName = "magrathea.brill-godzilla.ts.net";
            logLevel = 3;
            maxUploadSize = "16G";
            nginx.recommendedHttpHeaders = true;

            phpOptions = {
                "opcache.enable" = "1";
                "opcache.enable_cli" = "1";
                "opcache.fast_shutdown" = "1";
                "opcache.interned_strings_buffer" = "16";
                "opcache.max_accelerated_files" = "10000";
                "opcache.memory_consumption" = "512";
                "opcache.revalidate_freq" = "1";
                "opcache.save_comments" = "1";
            };

            poolSettings = {
                "pm" = "ondemand";
                "pm.max_children" = 32;
                "pm.process_idle_timeout" = "10s";
                "pm.max_requests" = 500;
            };

            settings.trusted_domains = [ "magrathea.brill-godzilla.ts.net" ];
            settings.dbtableprefix = "nc_";

        };

        postgresql = {

            enable = true;
            package = pkgs.postgresql_16;

            ensureDatabases = [ "nextcloud" ];
            ensureUsers = [
                { name = "nextcloud"; ensureDBOwnership = true; }
            ];
            settings.max_connections = "300";
            settings.shared_buffers = "80MB";

        };

        postgresqlBackup = {
            enable = true;
            databases = [ "nextcloud" ];
            location = "/var/lib/nextcloud/dbbackup";
            startAt = "*-*-* 01:15:00";
        };

    };

    systemd.services.nextcloud-setup = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
    };

}

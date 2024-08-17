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
                adminpassFile = config.sops.secrets."nextcloud-admin".path;
                adminuser = "matt";
                dbhost = "/run/postgresql";
                dbname = "nextcloud";
                dbtype = "pgsql";
                dbuser = "nextcloud";
            };

            database.createLocally = true;
            enableImagemagick = false;

            extraApps = with config.services.nextcloud.package.packages.apps; {

                inherit calendar contacts deck mail notes talk tasks;

                news = pkgs.fetchNextcloudApp {
                    url = "https://github.com/nextcloud/news/releases/download/25.0.0-alpha8/news.tar.gz";
                    license = "agpl3Plus";
                    sha256 = "sha256-nj1yR2COwQ6ZqZ1/8v9csb/dipXMa61e45XQmA5WPwg=";
                };

                socialsharing_telegram = pkgs.fetchNextcloudApp {
                    url = "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.1.0/socialsharing_telegram-v3.1.0.tar.gz";
                    license = "agpl3Plus";
                    sha256 = "sha256-qcjce8GOEPvb6v8hQQ0AuVf3dbcX3twjSZU0bQdOl3U=";
                };

            };

            extraAppsEnable = true;
            hostName = "magrathea.brill-godzilla.ts.net";
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

            settings = {
                dbtableprefix = "oc_";
                default_phone_region = "US";
                loglevel = 3;
                mail_sendmailmode = "pipe";
                mail_smtpmode = "sendmail";
                trusted_domains = [ "magrathea.brill-godzilla.ts.net" ];
                trusted_proxies = [ "magrathea" "nextcloud" ];
            };

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

    sops.secrets."nextcloud-admin".owner = "nextcloud";

    systemd.services.nextcloud-setup = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
    };

}

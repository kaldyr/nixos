{ config, pkgs, ... }: {

    environment.systemPackages = with pkgs; [
        ffmpeg
        imagemagick
        msmtp
    ];

    networking.firewall.allowedTCPPorts = [ 9000 ];
    networking.firewall.allowedUDPPorts = [ 9000 ];

    programs.msmtp = {
        enable = true;
        setSendmail = true;
        extraConfig = ''
            defaults
            auth on
            tls on
            tls_trust_file /var/lib/tailscale/certs/magrathea.brill-godzilla.ts.net.crt
        '';
    };

    services = {

        nextcloud = {

            enable = true;
            package = pkgs.nextcloud29;

            appstoreEnable = true;
            autoUpdateApps.enable = true;
            caching.redis = true;

            config = {
                adminpassFile = config.sops.secrets."nextcloud-admin".path;
                adminuser = "matt";
                dbhost = "/run/postgresql";
                dbname = "nextcloud";
                dbtype = "pgsql";
                dbuser = "nextcloud";
            };

            configureRedis = true;
            database.createLocally = true;
            enableImagemagick = true;

            extraApps = with config.services.nextcloud.package.packages.apps; {

                inherit calendar contacts deck groupfolders mail notes spreed tasks;

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
            hostName = "localhost";
            https = true;
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
                default_locale = "en_US";
                loglevel = 3;
                mail_sendmailmode = "pipe";
                mail_smtpmode = "sendmail";
                maintenance_window_start = "8";
                trusted_domains = [ "magrathea.brill-godzilla.ts.net" ];
                trusted_proxies = [ "100.109.171.26" "127.0.0.1" "192.168.1.2" ];
            };

        };

        nginx.virtualHosts."localhost" = {
            forceSSL = false;
            listen = [ { addr = "127.0.0.1"; port = 9000; } ];
            sslCertificate = "/var/lib/tailscale/certs/magrathea.brill-godzilla.ts.net.crt";
            sslCertificateKey = "/var/lib/tailscale/certs/magrathea.brill-godzilla.ts.net.key";
        };

        postgresql = {
            enable = true;
            package = pkgs.postgresql_16;
            ensureDatabases = [ "nextcloud" ];
            ensureUsers = [ { name = "nextcloud"; ensureDBOwnership = true; } ];
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

    users.extraUsers.postgresql.isSystemUser = true;
    users.extraUsers.postgresql.extraGroups = [ "nextcloud" ];

}

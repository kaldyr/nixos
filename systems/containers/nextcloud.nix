{ config, pkgs, ... }: let

    nextcloudHome = "/srv/nextcloud";

in {

    environment.systemPackages = with pkgs; [ mariadb ];

    containers.nextcloud = {

        networking.firewall = {
            allowedTCPPorts = [ 9000 ];
            allowedUDPPorts = [ 9000 ];
        };

        services = {

            mysql = {
                enable = true;
                dataDir = "${nextcloudHome}/mysql";
                package = pkgs.mariadb;
            };

            nextcloud = {
                enable = true;
                package = pkgs.nextcloud27;

                appstoreEnable = true;
                autoUpdateApps = true;
                caching.redis = true;

                config = {
                    adminuser = "admin";
                    # adminpassFile = ""; # Replace with sops-nix
                    dbhost = "localhost";
                    dbname = "nextcloud";
                    dbtype = "mysql";
                    dbuser = "nextcloud";
                    defaultPhoneRegion = "US";
                    trustedProxies = "";
                };

                configureRedis = true;
                database.createLocally = true;
                datadir = "${nextcloudHome}";
                enableImagemagick = false;

                extraApps = with config.services.nextcloud.package.packages.apps; {
                    inherit calendar contacts mail news notes tasks;
                };

                extraAppsEnable = true;

                extraOptions = {
                    mail_sendmailmode = "pipe";
                    mail_smtpmode = "sendmail";
                };

                hostname = "";
                logLevel = 3;
                maxUploadSize = "4G";
                nginx.recommendedHttpHeaders = true;

                # phpOptions = {
                    # "opcache.enable" = "1";
                    # "opcache.enable_cli" = "1";
                    # "opcache.interned_strings_buffer" = "10";
                    # "opcache.max_accelerated_files" = "10000";
                    # "opcache.revalidate_freq" = "1";
                    # "opcache.save_comments" = "1";
                    # "opcache.memory_consumption" = "512";
                    # "opcache.jit" = "1255";
                    # "opcache.jit_buffer_size" = "128M";
                # };

            };

        };

        systemd.services."nextcloud-setup" = {
            requires = [ "mariadb.service" ];
            after = [ "mariadb.service" ];
        };

    };

}

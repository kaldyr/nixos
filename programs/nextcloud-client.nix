{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.services.nextcloud-client = {

        enable = true;

        package = pkgs.nextcloud-client;
        startInBackground = true;

    };

}

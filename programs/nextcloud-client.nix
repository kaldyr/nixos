{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];
    };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ nextcloud-client ];
        
        services.nextcloud-client = {

            enable = true;

            package = pkgs.nextcloud-client;
            startInBackground = true;

        };
        
    };

}

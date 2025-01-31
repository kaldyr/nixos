{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            nextcloud-client
            nextcloud-talk-desktop
        ];

        services.nextcloud-client = {
            enable = true;
            package = pkgs.nextcloud-client;
            startInBackground = true;
        };

        xdg.configFile."Nextcloud/nextcloud.cfg".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/Nextcloud/${sysConfig.hostname}.cfg";

    };

}

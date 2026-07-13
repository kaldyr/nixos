{ lib, sysConfig, ... }: {
    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        services.nextcloud-client.enable = true;
        services.nextcloud-client.startInBackground = true;
        xdg.configFile."Nextcloud/nextcloud.cfg".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/nextcloud/config/${sysConfig.hostname}.cfg";
    };
}

{ sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        services.easyeffects.enable = true;
        home.file.".local/share/easyeffects".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/easyeffects/config";
    };
}

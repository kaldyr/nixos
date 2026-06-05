{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ satty ];
        xdg.configFile."satty/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/satty/config/config.toml";
    };

}

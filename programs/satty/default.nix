{ sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.satty.enable = true;
        xdg.configFile."satty/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/satty/config/config.toml";
    };
}

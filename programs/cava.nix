{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.cava.enable = true;
        xdg.configFile."cava/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/cava/config";
    };

}

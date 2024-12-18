{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.starship.enable = true;
        programs.starship.enableFishIntegration = true;
        xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/starship.toml";
    };

}

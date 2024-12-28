{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.bat.enable = true;
        xdg.configFile."bat/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/bat/config";
        xdg.configFile."bat/themes".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/bat/themes";
    };

}

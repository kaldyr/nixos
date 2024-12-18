{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.bat.enable = true;
        xdg.configFile."bat".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/bat";
    };

}

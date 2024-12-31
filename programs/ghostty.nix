{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.wezterm.enable = true;
        xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/ghostty/config";
    };

}

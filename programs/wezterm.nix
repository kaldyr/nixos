{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.wezterm.enable = true;
        xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/wezterm/wezterm.lua";
    };

}

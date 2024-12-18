{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.waybar.enable = true;
        xdg.configFile."waybar/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/waybar/config_${sysConfig.hostname}";
        xdg.configFile."waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/waybar/style.css";
    };

}

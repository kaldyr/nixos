{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ ghostty ];
        xdg.configFile."ghostty".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/ghostty";
    };

}

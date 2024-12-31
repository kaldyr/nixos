{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ ghostty ];
        xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/ghostty/config";
    };

}

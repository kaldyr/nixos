{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ numbat ];
        xdg.configFile."numbat/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/numbat/config.toml";
    };

}

{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ kitty ];
        xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/kitty";

    };

}

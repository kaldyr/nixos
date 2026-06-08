{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            dotool
            keepassxc
            keepmenu
        ];

        xdg.configFile."keepmenu/config.ini".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/keepmenu/config.ini";

    };

}

{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ btop ];
        xdg.configFile."btop".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/btop";
        xdg.desktopEntries.btop = { name = "btop++"; noDisplay = true; };
    };

}

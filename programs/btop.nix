{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.btop.enable = true;
        xdg.configFile."btop/btop.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/btop/btop.conf";
        xdg.configFile."btop/themes".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/btop/themes";
        xdg.desktopEntries.btop = { name = "btop++"; noDisplay = true; };
    };

}

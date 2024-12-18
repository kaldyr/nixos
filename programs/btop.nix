{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.btop.enable = true;
        xdg.configFile."btop".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/bat";
        xdg.desktopEntries.btop = { name = "btop++"; noDisplay = true; };
    };

}

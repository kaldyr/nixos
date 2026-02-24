{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ libsixel ];
        programs.foot.enable = true;
        xdg.configFile."foot/foot.ini".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/foot/${sysConfig.hostname}.ini";
        xdg.desktopEntries."footclient" = { name = "Foot Client"; noDisplay = true; };
        xdg.desktopEntries."foot-server" = { name = "Foot Server"; noDisplay = true; };
    };

}

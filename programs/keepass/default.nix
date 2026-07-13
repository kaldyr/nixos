{ pkgs, sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ dotool keepmenu ];
        programs.keepassxc.enable = true;
        xdg.configFile."keepmenu/config.ini".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/keepass/config/config.ini";
    };
}

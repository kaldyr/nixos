{ pkgs, sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ wlr-which-key ];
        xdg.configFile."wlr-which-key/config.yaml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/wlr-which-key/config/config.yaml";
    };
}

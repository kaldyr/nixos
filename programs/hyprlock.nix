{ pkgs, sysConfig, ... }: {


    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ hyprlock ];
        xdg.configFile."hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/hypr/hyprlock.conf";
    };

}

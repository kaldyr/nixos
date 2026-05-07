{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ hypridle ];
        services.hypridle.enable = true;
        xdg.configFile."hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/hypr/hypridle.conf";

    };

}

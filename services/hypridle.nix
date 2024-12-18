{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ hypridle ];

        services.hypridle.enable = (
            # Mjolnir hyprlock crash when left for minutes
            if sysConfig.hostname == "mjolnir" then false
            else true
        );

        xdg.configFile."hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/hypr/hypridle.conf";

    };

}

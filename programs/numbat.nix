{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ numbat ];

        xdg.configFile."numbat/config.toml".text = /* toml */ ''
            intro-banner = "short"
            prompt = "> "
            pretty-print = "auto"

            [exchange-rates]
            fetching-policy = "on-startup"
        '';

    };

}

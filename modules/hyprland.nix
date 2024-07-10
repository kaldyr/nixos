{ pkgs, sysConfig, ... }: {

    services.greetd = {

        enable = true;

        settings = rec {
            default_session = initial_session;
            initial_session.command = "${pkgs.hyprland}/bin/Hyprland 1>/dev/null";
            initial_session.user = sysConfig.user;
        };

    };

}

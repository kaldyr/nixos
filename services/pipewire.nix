{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ pamixer ];

    security.rtkit.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };

}

{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ pamixer ];

    security.rtkit.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber = {
            enable = true;
            extraConfig = {
                "10-bluez" = {
                    "monitor.bluez.properties" = {
                        "bluez5.enable-sbc-xq" = true;
                        "bluez5.enable-msbc" = true;
                        "bluez5.enable-hw-volume" = true;
                        "bluez5.codecs" = ["sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd"];
                    };
                };
            };
        };
    };

}

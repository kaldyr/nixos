{ pkgs, sysConfig,... }: {

    fonts = {

        enableDefaultPackages = false;

        fontconfig.defaultFonts = {
            monospace = [ "IntoneMono Nerd Font" "Noto Color Emoji" ];
            sansSerif = [ "Ubuntu Nerd Font" "Noto Color Emoji" ];
            serif = [ "Liberation Serif" "Noto Color Emoji" ];
            emoji = [ "Noto Color Emoji" ];
        };

        packages = with pkgs; [
            font-awesome # Symbols
            liberation_ttf # Open versions of MS fonts
            (nerdfonts.override { fonts = [
                "IntelOneMono" # Main system mono font
                "NerdFontsSymbolsOnly" # Nerd Font Symbols
                "Ubuntu" # Main system font
            ]; })
            noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
            noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
            noto-fonts-emoji # Symbols
        ];

    };

    hardware = {

        bluetooth.enable = true;
        bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";

        opengl = {
            enable = true;
            driSupport = true;
            extraPackages = with pkgs; [
                libdrm
                libva
                libva-utils
                vaapiVdpau
            ];
        };

    };

    security.polkit.enable = true;
    security.rtkit.enable = true;

    services = {

        blueman.enable = true;

        greetd = {
            enable = true;
            settings = rec {
                default_session = initial_session;
                initial_session.command = "${pkgs.hyprland}/bin/Hyprland 1>/dev/null";
                initial_session.user = sysConfig.user;
            };
        };

        keyd.enable = true;
        keyd.keyboards.default.settings.main.capslock = "esc";

        pipewire = {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
            wireplumber.enable = true;
        };

        udisks2.enable = true;

        xserver = {
            excludePackages = with pkgs; [ xterm ];
            xkb.layout = "us";
            xkb.variant = "";
        };

    };

}

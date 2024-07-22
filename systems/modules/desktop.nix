{ pkgs, sysConfig,... }: {

    fonts = {

        enableDefaultPackages = false;

        fontconfig = {
            defaultFonts = {
                # monospace = [ "IntoneMono Nerd Font" "Noto Color Emoji" ];
                monospace = [ "Recursive Mn Csl St" "Noto Color Emoji" ];
                # sansSerif = [ "Ubuntu Nerd Font" "Noto Color Emoji" ];
                sansSerif = [ "Inter" "Liberation Sans" "Noto Color Emoji" ];
                serif = [ "Liberation Serif" "Noto Color Emoji" ];
                emoji = [ "Noto Color Emoji" ];
            };
            localConf = /* xml */ ''
                <?xml version="1.0"?>
                <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
                <fontconfig>
                    <match target="font">
                        <test qual="any" name="family"><string>Inter</string></test>
                        <!-- https://rsms.me/inter/#features -->
                        <edit name="fontfeatures" mode="prepend">
                            <!-- Contextural alternatives -->
                            <string>calt</string>
                            <!-- Tabular numbers -->
                            <string>tnum</string>
                            <!-- Case alternates -->
                            <string>case</string>
                            <!-- Compositions -->
                            <string>ccmp</string>
                            <!-- Superscript -->
                            <!-- <string>sups</string> -->
                            <!-- Subscript -->
                            <!-- <string>subs</string> -->
                            <!-- Denominators -->
                            <!-- <string>dnom</string> -->
                            <!-- Numerators -->
                            <!-- <string>numr</string> -->
                            <!-- Alternative one -->
                            <string>cv01</string>
                            <!-- Open four -->
                            <string>cv02</string>
                            <!-- Open six -->
                            <string>cv03</string>
                            <!-- Open nine -->
                            <string>cv04</string>
                            <!-- Slashed zero -->
                            <string>zero</string>
                            <!-- Simplified U -->
                            <string>cv06</string>
                            <!-- Upper case i with serif -->
                            <string>cv08</string>
                            <!-- Lower case L with tail -->
                            <string>cv05</string>
                            <!-- Round quotes & commas -->
                            <string>ss03</string>
                        </edit>
                    </match>
                    <match target="font">
                        <test qual="any" name="family"><string>Recursive</string></test>
                        <!-- https://github.com/arrowtype/recursive#opentype-features -->
                        <edit name="fontfeatures" mode="prepend">
                            <!-- Code ligatures -->
                            <string>dlig on</string>
                            <!-- Single-story 'a' -->
                            <!-- <string>ss01</string> --> 
                            <!-- Single-story 'g' -->
                            <string>ss02</string>
                            <!-- Simplified mono 'at'@ -->
                            <!-- <string>ss12</string> -->
                            <!-- Uppercase punctuation -->
                            <string>case</string>
                            <!-- Slashed zero -->
                            <string>ss20</string>
                        </edit>
                    </match>
                </fontconfig>
            '';
        };

        packages = with pkgs; [
            font-awesome # Symbols
            inter
            liberation_ttf # Open versions of MS fonts
            (nerdfonts.override { fonts = [
                "IntelOneMono" # Main system mono font
                "NerdFontsSymbolsOnly" # Nerd Font Symbols
                "Ubuntu" # Main system font
            ]; })
            noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
            noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
            noto-fonts-emoji # Symbols
            recursive
        ];

    };

    hardware = {

        bluetooth.enable = true;
        bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";

        graphics = {
            enable = true;
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

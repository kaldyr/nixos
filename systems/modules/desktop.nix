{ pkgs, ... }: {

    fonts = {

        enableDefaultPackages = false;

        fontconfig = {
            defaultFonts = {
                monospace = [ "Recursive Mn Csl St" "Noto Color Emoji" ];
                sansSerif = [ "Inter" "Liberation Sans" "Noto Color Emoji" ];
                serif = [ "Inter" "Liberation Serif" "Noto Color Emoji" ];
                emoji = [ "Noto Color Emoji" ];
            };
            localConf = /* xml */ ''
                <?xml version="1.0"?>
                <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
                <fontconfig>
                    <match target="font">
                        <test qual="any" name="family" compare="contains"><string>Inter</string></test>
                        <!-- https://rsms.me/inter/#features -->
                        <edit name="fontfeatures" mode="assign_replace">
                            <!-- Contextural alternatives -->
                            <string>calt</string>
                            <!-- Tabular numbers -->
                            <string>tnum</string>
                            <!-- Case alternates -->
                            <string>case</string>
                            <!-- Compositions -->
                            <string>ccmp</string>
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
                        <test qual="any" name="family" compare="contains"><string>Recursive</string></test>
                        <!-- https://github.com/arrowtype/recursive#opentype-features -->
                        <edit name="fontfeatures" mode="assign_replace">
                            <!-- Code ligatures -->
                            <string>dlig on</string>
                            <!-- Simplified f -->
                            <string>ss03</string>
                            <!-- Simplified i -->
                            <string>ss04</string>
                            <!-- Simplified l -->
                            <string>ss05</string>
                            <!-- Simplified r -->
                            <string>ss06</string>
                            <!-- Simplified italic Diagonals -->
                            <string>ss07</string>
                            <!-- No-serif L & Z -->
                            <string>ss08</string>
                            <!-- Simplified 6 & 9 -->
                            <string>ss09</string>
                            <!-- Dotted 0 -->
                            <string>ss10</string>
                            <!-- Simplified 1 -->
                            <string>ss11</string>
                            <!-- Simplified mono 'at'@ -->
                            <string>ss12</string>
                            <!-- Uppercase punctuation -->
                            <string>case</string>
                            <!-- Italic ligatures -->
                            <string>liga</string>
                        </edit>
                    </match>
                </fontconfig>
            '';
        };

        packages = with pkgs; [
            font-awesome # Symbols
            inter # System Sans Font
            liberation_ttf # Open versions of MS fonts
            (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
            noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
            noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
            noto-fonts-emoji # Symbols
            recursive # System Mono Font
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

{ pkgs, sysConfig, ... }: {

    imports = [
        ../programs/cava.nix
        ../programs/discord.nix
        ../programs/libreoffice.nix
        ../programs/librewolf.nix
        ../programs/mpv.nix
        ../programs/newsboat.nix
        ../programs/obsidian.nix
        ../programs/telegram.nix
        ../programs/zathura.nix
    ];

    home-manager.users.${sysConfig.user} = {

        fonts.fontconfig.enable = true;

        gtk = {

            enable = true;

            cursorTheme = {
                name = "catppuccin-frappe-sapphire-cursors";
                package = pkgs.catppuccin-cursors.frappeSapphire;
                size = 24;
            };

            font = {
                name = "Inter";
                package = pkgs.inter;
                size = 11;
            };

            gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
            gtk4.extraConfig.gtk-applications-prefer-dark-theme = true;

            iconTheme = {
                name = "Papirus";
                package = pkgs.catppuccin-papirus-folders.override {
                    accent = "sapphire";
                    flavor = "frappe";
                };
            };

            theme = {
                name = "catppuccin-frappe-sapphire-standard";
                package = pkgs.catppuccin-gtk.override {
                    accents = [ "sapphire" ];
                    size = "standard";
                    variant = "frappe";
                };
            };

        };

        home = {

            packages = with pkgs; [
                ffmpegthumbnailer
                gimp
                hunspell
                hunspellDicts.en_US
                imagemagick
                kjv
                networkmanagerapplet
                neovide
                papirus-folders
                vulkan-tools
                xdg-utils
                xdg-user-dirs
                yt-dlp
            ];

            pointerCursor = {
                name = "catppuccin-frappe-sapphire-cursors";
                package = pkgs.catppuccin-cursors.frappeSapphire;
                size = 24;
                gtk.enable = true;
                x11.enable = true;
            };

            sessionVariables = {
                GTK_THEME = "catppuccin-frappe-sapphire-standard";
                XCURSOR_THEME = "catppuccin-frappe-sapphire-cursors";
                XCURSOR_SIZE = 24;
            };

        };


        services = {
            blueman-applet.enable = true;
            gnome-keyring.enable = true;
            network-manager-applet.enable = true;
        };

        xdg = {

            configFile = {
                "BetterDiscord/themes/frappe.theme.css".source = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "discord";
                    rev = "b9f42df1b9b38957a4d8b7e74637a5480be9be57";
                    sha256 = "sha256-ArhHQSuXc04Tti7pd5EfScm7szhBmS1hcEOE9q+wj/E=";
                } + "/themes/frappe.theme.css";
                "mimeapps.list".force = true;
            };

            mimeApps.enable = true;

            userDirs = {
                enable = true;
                createDirectories = true;
                desktop = null;
                publicShare = null;
                templates = null;
            };

        };

    };

    fonts = {

        enableDefaultPackages = false;

        fontconfig = {
            defaultFonts = {
                monospace = [ "Recursive Mn Csl St" "Noto Color Emoji" ];
                sansSerif = [ "Inter" "Liberation Sans" "Noto Color Emoji" ];
                serif = [ "Recursive Sa Ln St" "Liberation Serif" "Noto Color Emoji" ];
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

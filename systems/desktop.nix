{ pkgs, sysConfig, ... }: {

    imports = [
        ../services/keyd.nix
        ../services/pipewire.nix
        ../programs/cava.nix
        ../programs/discord.nix
        ../programs/libreoffice.nix
        ../programs/librewolf.nix
        ../programs/mpv.nix
        ../programs/nextcloud-desktop.nix
        ../programs/obsidian.nix
        ../programs/openscad.nix
        ../programs/telegram.nix
        ../programs/zathura.nix
    ];

    environment = {

        etc."fuse.conf".text = /* bash */ ''
            user_allow_other
        '';

        # Home files that need to be preserved between boots
        #  These files are synced and do not need to be in snapshots 
        persistence."/nix" = {

            hideMounts = true;

            users.${sysConfig.user}.directories = [
                ".local/share/applications"
                "Books"
                "Documents"
                "Downloads"
                "Music"
                "Notes"
                "Pictures"
                "Projects"
                "Videos"
            ];

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
                            <string>calt</string> <!-- Contextural alternatives -->
                            <string>case</string> <!-- Case alternates -->
                            <string>ccmp</string> <!-- Compositions -->
                            <string>cv02</string> <!-- Open four -->
                            <string>cv03</string> <!-- Open six -->
                            <string>cv04</string> <!-- Open nine -->
                            <string>cv05</string> <!-- Lower case L with tail -->
                            <string>cv06</string> <!-- Simplified U -->
                            <string>cv08</string> <!-- Upper case i with serif -->
                            <string>ss03</string> <!-- Round quotes & commas -->
                            <string>tnum</string> <!-- Tabular numbers -->
                            <string>zero</string> <!-- Slashed zero -->
                        </edit>
                    </match>
                    <match target="font">
                        <test qual="any" name="family" compare="contains"><string>Recursive</string></test>
                        <!-- https://github.com/arrowtype/recursive#opentype-features -->
                        <edit name="fontfeatures" mode="assign_replace">
                            <string>case</string> <!-- Uppercase punctuation -->
                            <string>dlig</string> <!-- Code ligatures -->
                            <string>ss01</string> <!-- Single-story 'a' -->
                            <!-- <string>ss02</string> Single-story 'g' -->
                            <string>ss03</string> <!-- Simplified f -->
                            <string>ss04</string> <!-- Simplified i -->
                            <string>ss05</string> <!-- Simplified l -->
                            <string>ss06</string> <!-- Simplified r -->
                            <string>ss07</string> <!-- Simplified italic Diagonals -->
                            <string>ss08</string> <!-- No-serif L & Z -->
                            <string>ss09</string> <!-- Simplified 6 & 9 -->
                            <string>ss10</string> <!-- Dotted 0 -->
                            <string>ss11</string> <!-- Simplified 1 -->
                            <string>ss12</string> <!-- Simplified mono 'at'@ -->
                            <string>titl</string> <!-- No descender on 'Q' -->
                        </edit>
                    </match>
                </fontconfig>
            '';

        };

        packages = with pkgs; [
            font-awesome # Symbols
            inter # System Sans Font
            liberation_ttf # Open versions of MS fonts
            ( nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; } )
            noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
            noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
            noto-fonts-emoji # Symbols
            recursive # System Mono Font
        ];

    };

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
                android-tools
                gimp
                gnome-keyring
                gnuplot
                hunspell
                hunspellDicts.en_US
                imagemagick
                kjv
                libsecret
                lowfi
                networkmanagerapplet
                papirus-folders
                vulkan-tools
                xdg-utils
                xdg-user-dirs
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

        services.blueman-applet.enable = true;
        services.network-manager-applet.enable = true;

        xdg = {

            configFile."mimeapps.list".force = true;
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

    programs.dconf.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    security.polkit.enable = true;

    services = {

        blueman.enable = true;
        dbus.enable = true;
        gnome.gnome-keyring.enable = true;

        # Work towards automount phone for file copy
        udev.packages = with pkgs; [
            android-udev-rules
            libmtp
            media-player-info
        ];

        udisks2.enable = true;
        udisks2.mountOnMedia = true;

        xserver = {
            excludePackages = with pkgs; [ xterm ];
            xkb.layout = "us";
            xkb.variant = "";
        };

    };

}

{ lib, pkgs, sysConfig, ... }: {

    imports = [
        ../programs/cava.nix
        ../programs/discord.nix
        ../programs/ghostty.nix
        ../programs/keepass.nix
        ../programs/libreoffice.nix
        ../programs/librewolf.nix
        ../programs/mpv.nix
        ../programs/newsboat.nix
        ../programs/obsidian.nix
        ../programs/telegram.nix
        ../programs/termusic.nix
        ../programs/zathura.nix
        ../services/pipewire.nix
    ];

    environment = {

        etc."fuse.conf".text = /* bash */ ''
            user_allow_other
        '';

        # Home files that need to be preserved between boots
        #  These files are synced and do not need to be in snapshots

        persistence = lib.mkIf sysConfig.homeImpermanence {
            "/nix" = {
                hideMounts = true;
                users.${sysConfig.user}.directories = [
                    ".config/gnome-games"
                    ".local/share/applications"
                    "Books"
                    "Documents"
                    "DnD"
                    "Downloads"
                    "Music"
                    "Notes"
                    "Pictures"
                    "Projects"
                    "Roms"
                    "Videos"
                ];
            };
        };

    };

    fonts = {

        enableDefaultPackages = false;

        fontconfig = {

            antialias = true;

            defaultFonts = {
                emoji = [ "Noto Color Emoji" ];
                monospace = [
                    "Liga Rec Mono Custom"
                    "JuliaMono"
                    "Noto Sans Mono CJK HK"
                    "Noto Sans Mono CJK JP"
                    "Noto Sans Mono CJK KR"
                    "Noto Sans Mono CJK SC"
                    "Noto Sans Mono CJK TC"
                ];
                sansSerif = [
                    "Recursive Sans Casual Static"
                    "Inter"
                    "Liberation Sans"
                    "Noto Color Emoji"
                    "Noto Sans CJK HK"
                    "Noto Sans CJK JP"
                    "Noto Sans CJK KR"
                    "Noto Sans CJK SC"
                    "Noto Sans CJK TC"
                ];
                serif = [
                    "Libertinus Serif"
                    "Liberation Serif"
                    "Noto Serif CJK HK"
                    "Noto Serif CJK JP"
                    "Noto Serif CJK KR"
                    "Noto Serif CJK SC"
                    "Noto Serif CJK TC"
                ];
            };

            hinting.enable = true;

            localConf = /* xml */ ''
                <?xml version='1.0'?>
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
                            <string>ss20</string>
                            <string>case</string>
                            <string>liga</string>
                        </edit>
                    </match>
                </fontconfig>
            '';

            subpixel.rgba = "rgb";
            subpixel.lcdfilter = "default";

        };

        packages = with pkgs; [
            font-awesome # Symbols
            inter # Sans Font
            julia-mono # Math font
            liberation_ttf # Open versions of MS fonts
            libertinus # System Serif Font
            maple-mono-7
            noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
            noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
            noto-fonts-color-emoji # Symbols
            recursive # System sans font
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
                name = "Recursive Sans Casual Static";
                package = pkgs.recursive;
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
                aisleriot
                blender
                gimp
                gnome-keyring
                gnuplot
                helium
                hunspell
                hunspellDicts.en_US
                imagemagick
                (inkscape-with-extensions.override {
                    inkscapeExtensions = with pkgs; [
                        inkscape-extensions.inkstitch
                    ];
                })
                kjv
                libsecret
                lowfi
                networkmanagerapplet
                papirus-folders
                sblast
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
                libva-vdpau-driver
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
        # udev.packages = with pkgs; [
        #     libmtp
        #     media-player-info
        # ];

        udisks2.enable = true;
        udisks2.mountOnMedia = true;

        xserver = {
            excludePackages = with pkgs; [ xterm ];
            xkb.layout = "us";
            xkb.variant = "";
        };

    };

}

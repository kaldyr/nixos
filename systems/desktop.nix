{ pkgs, sysConfig, ... }: {

    imports = [
        ../settings/fonts.nix
        ../services/keyd.nix
        ../services/pipewire.nix
        ../programs/cava.nix
        ../programs/discord.nix
        ../programs/libreoffice.nix
        ../programs/librewolf.nix
        ../programs/mpv.nix
        ../programs/nextcloud-client.nix
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

    home-manager.users.${sysConfig.user} = {

        gtk = {

            enable = true;

            cursorTheme = {
                name = "catppuccin-frappe-sapphire-cursors";
                package = pkgs.catppuccin-cursors.frappeSapphire;
                size = 24;
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
                hunspell
                hunspellDicts.en_US
                imagemagick
                kjv
                libsecret
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

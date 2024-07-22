{ pkgs, ... }: {

    imports = [
        ./programs/cava.nix
        ./programs/mpv.nix
        ./programs/newsboat.nix
        ./programs/zathura.nix
    ];

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
            # Base desktop
            ffmpegthumbnailer
            hunspell
            hunspellDicts.en_US
            imagemagick
            kjv
            networkmanagerapplet
            papirus-folders
            vulkan-tools
            xdg-utils
            xdg-user-dirs
            # Applications
            discord
            gimp
            libreoffice
            neovide
            obsidian
            telegram-desktop
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

}

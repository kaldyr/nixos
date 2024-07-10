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

        cursorTheme.name = "Catppuccin-Frappe-Sapphire-Cursors";
        cursorTheme.size = 24;
        font.name = "Ubuntu Nerd Font";
        font.size = 10;

        gtk3.extraConfig.Settings = ''
            gtk-application-prefer-dark-theme = 1
        '';

        gtk4.extraConfig.Settings = ''
            gtk-applications-prefer-dark-theme = 1
        '';

        iconTheme.name = "Papirus";
        theme.name = "Catppuccin-Frappe-Standard-Sapphire-Dark";

    };

    home = {

        packages = with pkgs; [
            # Base desktop
            catppuccin-cursors.frappeSapphire
            (catppuccin-gtk.override { accents = [ "sapphire" ]; variant = "frappe"; })
            (catppuccin-papirus-folders.override { accent = "sapphire"; flavor = "frappe"; })
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
            vesktop
        ];

        pointerCursor = {
            name = "Catppuccin-Frappe-Sapphire-Cursors";
            package = pkgs.catppuccin-cursors.frappeSapphire;
            gtk.enable = true;
            x11.enable = true;
        };

        sessionVariables = {
            GTK_THEME = "Catppuccin-Frappe-Standard-Sapphire-Dark";
            XCURSOR_SIZE = 24;
            XCURSOR_THEME = "Catppuccin-Frappe-Teal-Cursors";
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

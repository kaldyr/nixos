{ pkgs, sysConfig, ... }: {

    imports = [
        ../services/dunst.nix
        ../services/gammastep.nix
        ../services/hypridle.nix
        ../services/swww.nix
        ../services/udiskie.nix
        ./feh.nix
        ./foot.nix
        ./fuzzel.nix
        ./hyprlock.nix
        ./swappy.nix
        ./waybar.nix
    ];

    environment.sessionVariables = {
        HYPRCURSOR_THEME = "catppuccin-frappe-sapphire-cursors";
        HYPRCURSOR_SIZE = 24;
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            brightnessctl
            cliphist
            grim
            hyprcursor
            hyprpicker
            libnotify
            pavucontrol
            playerctl
            polkit_gnome
            slurp
            tesseract
            wl-clipboard
            wl-screenrec
            wtype
        ];

        services.cliphist.enable = true;
        services.playerctld.enable = true;

        wayland.windowManager.hyprland = {
            enable = true;
            extraConfig = /* hyprlang */ ''
                source = ~/.config/hypr/hyprland/frappe.conf
                source = ~/.config/hypr/hyprland/${sysConfig.hostname}.conf
                source = ~/.config/hypr/hyprland/common.conf
            '';
        };

        xdg.configFile."hypr/hyprland".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/hypr/hyprland";

        xdg.mimeApps.defaultApplications = {
            "default-web-browser" = [ "librewolf.desktop" ];
            "text/html" = [ "librewolf.desktop" ];
            "x-scheme-handler/ftp" = [ "librewolf.desktop" ];
            "x-scheme-handler/http" = [ "librewolf.desktop" ];
            "x-scheme-handler/https" = [ "librewolf.desktop" ];
            "application/md" = [ "librewolf.desktop" ];
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];
            "application/image" = [ "feh.desktop" ];
            "application/video" = [ "mpv.desktop" ];
            "application/audio" = [ "mpv.desktop" ];
        };

    };

    services.greetd = {

        enable = true;

        settings = rec {
            default_session = initial_session;
            initial_session.command = "Hyprland";
            initial_session.user = sysConfig.user;
        };

    };

    xdg.portal = {

        enable = true;

        config.common.default = "*";

        configPackages = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal
        ];

        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            xdg-desktop-portal
        ];

        wlr.enable = true;

    };

}

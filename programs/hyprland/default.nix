{ lib, pkgs, sysConfig, ... }: {

    imports = [
        ../../services/awww.nix
        ../../services/dunst.nix
        ../../services/gammastep.nix
        ../../services/hypridle.nix
        ../../services/udiskie.nix
        ../feh.nix
        ../fuzzel.nix
        ../hyprlock.nix
        ../swappy.nix
        ../waybar.nix
    ];

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/hyprland"
            ".config/easyeffects"
            ".local/share/godot"
        ];
    };

    environment.systemPackages = with pkgs; [
        brightnessctl
        cliphist
        dragon-drop
        easyeffects
        grim
        hyprcursor
        hyprland
        hyprpicker
        hyprshutdown
        libnotify
        pavucontrol
        playerctl
        polkit_gnome
        slurp
        tesseract
        wl-clipboard
        wl-screenrec
        wtype
        xdg-desktop-portal-hyprland
        xwayland
    ];

    home-manager.users.${sysConfig.user} = { config, ... }: {

        services.cliphist.enable = true;
        services.playerctld.enable = true;

        xdg.configFile."hypr/hyprland.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprland.lua";

        xdg.mimeApps.defaultApplications = lib.mkForce {
            "default-web-browser" = [ "helium.desktop" ];
            "text/html" = [ "helium.desktop" ];
            "text/plain" = [ "nvim.desktop" ];
            "x-scheme-handler/ftp" = [ "helium.desktop" ];
            "x-scheme-handler/http" = [ "helium.desktop" ];
            "x-scheme-handler/https" = [ "helium.desktop" ];
            "application/md" = [ "helium.desktop" ];
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
            initial_session.command = "start-hyprland";
            initial_session.user = sysConfig.user;
        };

    };

    xdg.portal = {

        enable = true;

        config.common.default = "*";

        configPackages = with pkgs; [
            xdg-desktop-portal-hyprland
        ];

        extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
        ];

        wlr.enable = true;

    };

}

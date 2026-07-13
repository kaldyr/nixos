{ lib, pkgs, sysConfig, ... }: {

    imports = [
        ../../services/awww.nix
        ../../services/dunst.nix
        ../../services/udiskie.nix
        ../feh.nix
        ../fuzzel
        ../quickshell
        ../satty
        ../wlr-which-key
    ];

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/hyprland"
            ".config/easyeffects"
            ".local/share/godot"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.file.".local/share/nvim/stubs/hl.meta.lua".source = "${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua";

        home.packages = with pkgs; [
            brightnessctl
            grim
            hyprpicker
            hyprshutdown
            libnotify
            pavucontrol
            slurp
            tesseract
            wl-clipboard
            wl-screenrec
            xwayland
        ];

        home.pointerCursor.hyprcursor.enable = true;

        programs.hyprlock.enable = true;

        services = {
            cliphist.enable = true;
            easyeffects.enable = true;
            hypridle.enable = true;
            hyprpolkitagent.enable = true;
            hyprsunset.enable = true;
            playerctld.enable = true;
        };

        xdg.configFile = {
            "hypr/main.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprland.lua";
            "hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hypridle.conf";
            "hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprlock.conf";
            "hypr/hyprsunset.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprsunset.conf";
        };

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

        wayland.windowManager.hyprland = {
            enable = true;
            configType = "lua";
            extraConfig = ''
                require('main')
            '';
            package = null;
            portalPackage = null;
            systemd.enable = true;
        };

    };

    programs.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
        withUWSM = true;
    };

    services.greetd = {
        enable = true;

        settings = rec {
            default_session = initial_session;
            initial_session.command = "uwsm start hyprland.desktop";
            initial_session.user = sysConfig.user;
        };
    };

    xdg.portal = {
        enable = true;

        config.common.default = "*";
        configPackages = with pkgs; [ xdg-desktop-portal-hyprland ];
        extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
        wlr.enable = true;
    };
}

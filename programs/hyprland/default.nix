{
  lib,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ../../programs/feh
    ../../programs/fuzzel
    ../../programs/quickshell
    ../../programs/satty
    ../../programs/wlr-which-key
    ../../services/awww
    ../../services/dunst
    # ../../services/udiskie
  ];

  environment.sessionVariables."WLR_RENDERER" = "vulkan";

  home-manager.users.${sysConfig.user} = { config, ... }: {
    home.file.".local/share/nvim/stubs/hl.meta.lua".source =
      "${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua";

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
      hypridle.enable = lib.mkIf (sysConfig.hostname != "espresso") true;
      hyprpolkitagent.enable = true;
      hyprsunset.enable = true;
      playerctld.enable = true;
      xembed-sni-proxy.enable = true;
    };

    xdg.configFile = {
      "hypr/main.lua".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/main.lua";
      "hypr/systems".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/systems";
      "hypr/hypridle.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hypridle.conf";
      "hypr/hyprlock.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprlock.conf";
      "hypr/hyprsunset.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/hyprland/config/hyprsunset.conf";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      extraConfig = ''
        require('systems.${sysConfig.hostname}')
        require('main')
      '';
      package = null;
      portalPackage = null;
      systemd.enable = false;
    };

  };

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  services = {
    greetd = {
      enable = true;

      settings = rec {
        default_session = initial_session;
        initial_session.command = "uwsm start hyprland.desktop";
        initial_session.user = sysConfig.user;
      };
    };

    logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
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

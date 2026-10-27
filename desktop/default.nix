{
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./themes
    ./hyprland
    ./quickshell
    ../programs/cava
    ../programs/evince
    ../programs/helium
    ../programs/keepass
    ../programs/kitty
    ../programs/libreoffice
    ../programs/mpv
    ../programs/nautilus
    ../services/pipewire
  ];

  environment = {
    etc."fuse.conf".text = /* bash */ ''
      user_allow_other
    '';

    systemPackages = with pkgs; [
      # Applications
      gimp
      gnome-keyring
      gnuplot
      hunspell
      hunspellDicts.en_US
      imagemagick
      inkscape
      libsecret
      loupe
      networkmanagerapplet
      obsidian
      telegram-desktop
      vulkan-tools
      xdg-user-dirs
      xdg-utils
    ];
  };

  home-manager.users.${sysConfig.user}.xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps.enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      music = null;
      projects = null;
      publicShare = null;
      setSessionVariables = true;
      templates = null;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

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
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    xserver = {
      excludePackages = with pkgs; [ xterm ];
      xkb.layout = "us";
      xkb.variant = "";
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/${sysConfig.user}/Pictures 0755 ${sysConfig.user} users -"
    "d /home/${sysConfig.user}/Pictures/Wallpapers 0755 ${sysConfig.user} users -"
    "d /home/${sysConfig.user}/Pictures/Screenshots 0755 ${sysConfig.user} users -"
  ];
}

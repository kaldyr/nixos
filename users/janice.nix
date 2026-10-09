{
  config,
  lib,
  ...
}:
{
  home-manager.users."janice" = {
    home.sessionVariables = {
      EDITOR = "nano";
      VISUAL = "nano";
    };

    xdg.mimeApps.defaultApplications = lib.mkForce {
      "application/audio" = [ "mpv.desktop" ];
      "application/image" = [ "org.gnome.Loupe.desktop" ];
      "application/md" = [ "helium.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/video" = [ "mpv.desktop" ];
      "default-web-browser" = [ "firefox.desktop" ];
      "inode/directory" = [ "nautilus.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "text/plain" = [ "org.gnome.gedit.desktop" ];
      "x-scheme-handler/ftp" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  sops.secrets.janice-password.neededForUsers = true;

  users.users."janice" = {
    description = "Janice";
    hashedPasswordFile = config.sops.secrets.janice-password.path;
  };
}

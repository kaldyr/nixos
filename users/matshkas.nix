{
  config,
  lib,
  ...
}:
{
  home-manager.users."matshkas" = {
    home.sessionVariables = {
      EDITOR = "nano";
      VISUAL = "nano";
    };

    xdg.mimeApps.defaultApplications = lib.mkForce {
      "application/audio" = [ "mpv.desktop" ];
      "application/image" = [ "feh.desktop" ];
      "application/md" = [ "helium.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "application/video" = [ "mpv.desktop" ];
      "default-web-browser" = [ "helium.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "text/html" = [ "helium.desktop" ];
      "text/plain" = [ "nano.desktop" ];
      "x-scheme-handler/ftp" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };

  sops.secrets.matshkas-password.neededForUsers = true;

  users.users."matshkas" = {
    description = "Matshkas";
    hashedPasswordFile = config.sops.secrets.matshkas-password.path;
  };
}

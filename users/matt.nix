{
  config,
  lib,
  ...
}:
{
  home-manager.users."matt" = {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SOPS_AGE_KEY_FILE = "/state/age/keys.txt";
    };

    programs.git = {
      settings.user.email = "kaldyr@gmail.com";
      settings.user.name = "kaldyr";
      signing.format = "openpgp";
    };

    xdg.mimeApps.defaultApplications = lib.mkForce {
      "application/audio" = [ "mpv.desktop" ];
      "application/image" = [ "feh.desktop" ];
      "application/md" = [ "helium.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "application/video" = [ "mpv.desktop" ];
      "default-web-browser" = [ "helium.desktop" ];
      "text/html" = [ "helium.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
      "x-scheme-handler/ftp" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };

  programs.nano.enable = false;
  sops.secrets.matt-password.neededForUsers = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (subject.user == "matt" && action.id == "org.freedesktop.systemd1.manage-units") {
            return polkit.Result.YES;
        }
    });
  '';

  users.users."matt" = {
    description = "Matt";
    hashedPasswordFile = config.sops.secrets.matt-password.path;
  };
}

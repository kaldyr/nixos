{
  config,
  lib,
  pkgs,
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

  users = {
    mutableUsers = false;

    users."matt" = {
      description = "Matt";
      extraGroups = [
        "input"
        "networkmanager"
        "video"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets.matt-password.path;
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWSkGF1Yb4kkxWOUegI2yXFFYKcfsCyWWnu8LwHhImo matt@hofud"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEI16mw0+rV583qqsxv0zjEUfGgcwXczuOYFjWrDYmg matt@magrathea"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
      ];

      shell = pkgs.fish;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users."nic" = {
    home.sessionVariables = {
      EDITOR = "nano";
      VISUAL = "nano";
    };

    xdg.mimeApps.defaultApplications = lib.mkForce {
      "application/audio" = [ "mpv.desktop" ];
      "application/image" = [ "feh.desktop" ];
      "application/md" = [ "helium.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/video" = [ "mpv.desktop" ];
      "default-web-browser" = [ "helium.desktop" ];
      "inode/directory" = [ "nautilus.desktop" ];
      "text/html" = [ "helium.desktop" ];
      "text/plain" = [ "org.gnome.gedit.desktop" ];
      "x-scheme-handler/ftp" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };

  sops.secrets.nic-password.neededForUsers = true;

  users = {
    mutableUsers = false;

    users."nic" = {
      description = "Nichole";
      extraGroups = [
        "input"
        "networkmanager"
        "video"
        "wheel"
      ];
      hashedPasswordFile = config.sops.secrets.nic-password.path;
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
      ];

      shell = pkgs.fish;
    };
  };
}

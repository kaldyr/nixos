{
  lib,
  pkgs,
  ...
}:
{
  home-manager.users."nixos" = {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SOPS_AGE_KEY_FILE = "/state/age/keys.txt";
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

  users = {
    mutableUsers = false;

    users."nixos" = {
      description = "NixOS Installer";
      extraGroups = [
        "input"
        "networkmanager"
        "video"
        "wheel"
      ];

      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
}

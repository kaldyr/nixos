{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = {
    home.packages = with pkgs; [ helium ];

    xdg.mimeApps.associations.added = {
      "applications/md" = [ "helium.desktop" ];
      "text/html" = [ "helium.desktop" ];
      "x-scheme-handler/ftp" = [ "helium.desktop" ];
      "x-scheme-handler/http" = [ "helium.desktop" ];
      "x-scheme-handler/https" = [ "helium.desktop" ];
    };
  };
}

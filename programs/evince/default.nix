{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = {
    home.packages = with pkgs; [ evince ];
    xdg.mimeApps.associations.added."application/pdf" = [ "org.gnome.Evince.desktop" ];
  };
}

{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [ evince ];

  home-manager.users.${sysConfig.user}.xdg.mimeApps.associations.added."application/pdf" = [
    "org.gnome.Evince.desktop"
  ];
}

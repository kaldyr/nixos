{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    udiskie
    udisks
  ];

  home-manager.users.${sysConfig.user}.services.udiskie = {
    enable = true;
    automount = false;
    notify = true;
    tray = "auto";
  };

  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true;
}

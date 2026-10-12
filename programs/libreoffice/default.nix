{
  sysConfig,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    libreoffice
  ];

  home-manager.users.${sysConfig.user} = {
    xdg.desktopEntries = {
      base = {
        name = "LibreOffice Base";
        noDisplay = true;
      };

      impress = {
        name = "LibreOffice Impress";
        noDisplay = true;
      };

      math = {
        name = "LibreOffice Math";
        noDisplay = true;
      };

      startcenter = {
        name = "LibreOffice";
        noDisplay = true;
      };
    };
  };
}

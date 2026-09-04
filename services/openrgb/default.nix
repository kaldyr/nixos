{
  pkgs,
  ...
}:
{
  environment.persistence."/state".directories = [ "/var/lib/OpenRGB" ];

  environment.systemPackages = with pkgs; [ openrgb-with-all-plugins ];

  services = {
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    udev.packages = with pkgs; [ openrgb-with-all-plugins ];
  };
}

{
  pkgs,
  ...
}:
{
  environment.persistence."/state".directories = [ "/var/lib/OpenRGB" ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}

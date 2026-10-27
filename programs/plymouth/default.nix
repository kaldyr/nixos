{
  pkgs,
  ...
}:
{
  boot = {
    kernelParams = [ "splash" ];

    plymouth = {
      enable = true;
      themePackages = with pkgs; [ (catppuccin-plymouth.override { variant = "frappe"; }) ];
      theme = "catppuccin-frappe";
    };
  };
}

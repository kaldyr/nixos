{
  pkgs,
  sysConfig,
  ...
}:
let
  discord = pkgs.discord.override {
    withVencord = true;

    commandLineArgs =
      "--enable-blink-features=MiddleClickAutoscroll "
      + "--enable-features=WebRTCPipeWireCapturer,UseOzonePlatform "
      + "--ozone-platform=x11";
  };
in
{
  home-manager.users.${sysConfig.user} = {
    home.packages = with pkgs; [
      discord
      libevdev
      wayland-push-to-talk-fix
      xdotool
    ];

    xdg.configFile."Vencord/themes/frappe.theme.css".source =
      pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        rev = "f235754322320211a8646d963466fac402e5c297";
        sha256 = "sha256-7v1Hu6QofOyFOGnHeqHFK0JsxUxdJ9uTjI7nM7mdTsg=";
      }
      + "/themes/frappe.theme.css";
  };
}

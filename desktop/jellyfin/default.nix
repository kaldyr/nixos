{
  lib,
  pkgs,
  ...
}:
{
  environment = {
    persistence."/state".directories = [
      {
        directory = "/var/lib/jellyfin-client";
        user = "jellyfinclient";
        group = "media";
        mode = "0700";
      }
    ];

    systemPackages = with pkgs; [ mpv];
  };

  services.greetd = {
    enable = true;

    settings = rec {
      default_session = initial_session;

      initial_session = {
        command = "${pkgs.cage}/bin/cage -- ${pkgs.jellyfin-desktop}/bin/jellyfin-desktop --tv";
        user = "jellyfinclient";
      };
    };
  };

  users.users.jellyfinclient = {
    description = "Jellyfin Media Client";
    isSystemUser = true;

    group = "media";
    home = "/var/lib/jellyfin-client";
    createHome = true;

    extraGroups = [
      "audio"
      "input"
      "render"
      "video"
    ];
  };
}

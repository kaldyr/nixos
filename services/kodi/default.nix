{
  pkgs,
  sysConfig,
  ...
}:
let
  kodi = pkgs.kodi-gbm.withPackages (
    kodiPackages: with kodiPackages; [
      inputstream-adaptive
      inputstreamhelper
      youtube
    ]
  );
in
{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/kodi/.kodi";
    user = "kodi";
    group = "kodi";
    mode = "0700";
  }];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
  ];

  services.greetd = {
    enable = true;

    settings = rec {
      default_session = initial_session;
      initial_session.command = "${kodi}/bin/kodi-standalone";
      initial_session.user = "kodi";
    };
  };

  systemd.services.greetd.serviceConfig.LimitNOFILE = 65536;

  users.extraUsers."kodi" = {
    description = "Kodi Media Center";
    extraGroups = [
      "audio"
      "input"
      "media"
      "render"
      "video"
    ];

    group = "kodi";
    home = "/var/lib/kodi";
    isSystemUser = true;
  };

  users.users.${sysConfig.user}.extraGroups = [ "kodi" ];

  users.groups."kodi" = { };
}

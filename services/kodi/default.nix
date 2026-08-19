{
  pkgs,
  ...
}:
{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/kodi/.kodi";
    user = "kodi";
    group = "kodi";
    mode = "0700";
  }];

  environment.systemPackages = [
    (pkgs.kodi-gbm.withPackages (
      kodiPackages: with kodiPackages; [
        inputstream-adaptive
        inputstream-ffmpegdirect
        youtube
      ]
    ))
  ];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
  ];

  services.greetd = {
    enable = true;

    settings = rec {
      default_session = initial_session;
      initial_session.command = "${pkgs.kodi-gbm}/bin/kodi-standalone";
      initial_session.user = "kodi";
    };
  };

  systemd.services.greetd.serviceConfig.LimitNOFILE = 65536;

  users.extraUsers."kodi" = {
    description = "Kodi Media Center";
    extraGroups = [
      "audio"
      "input"
      "render"
      "video"
    ];

    group = "kodi";
    home = "/var/lib/kodi";
    isSystemUser = true;
  };

  users.groups."kodi" = { };
}

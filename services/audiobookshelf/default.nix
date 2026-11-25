{
  lib,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 13378 ];

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 13378;
  };

  systemd = {
    services.audiobookshelf = {
      after = [ "systemd-tmpfiles-setup.service" ];
      requires = [ "systemd-tmpfiles-setup.service" ];

      environment.BACKUP_PATH = "/state/audiobookshelf/metadata/backups";

      serviceConfig = {
        WorkingDirectory = lib.mkForce "/state/audiobookshelf";
        StateDirectory = lib.mkForce "";
      };

      unitConfig.RequiresMountsFor = [ "/state/audiobookshelf" ];
    };

    tmpfiles.rules = [
      "d /state/audiobookshelf 0750 audiobookshelf audiobookshelf -"
    ];

  };

  users.users.audiobookshelf = {
    home = lib.mkForce "/state/audiobookshelf";
    extraGroups = [ "media" ];
  };
}

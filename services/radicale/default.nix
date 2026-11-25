{
  lib,
  ...
}:
{
  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [ "127.0.0.1:5232" ];

      auth = {
        type = "htpasswd";
        htpasswd_filename = "/state/radicale/users";
        htpasswd_encryption = "autodetect";
      };

      rights = {
        type = "owner_only";
        permit_delete_collection = true;
      };

      sharing = {
        type = "files";
        collection_by_map = true;
        permit_create_map = true;
        default_permissions_create_map = "rw";
      };

      storage.filesystem_folder = "/state/radicale/collections";
    };
  };

  systemd = {
    services.radicale = {
      serviceConfig = {
        ReadWritePaths = [ "/state/radicale" ];
        StateDirectory = lib.mkForce "";
        WorkingDirectory = lib.mkForce "/state/radicale";
      };

      unitConfig.RequiresMountsFor = [ "/state/radicale" ];
    };

    tmpfiles.rules = [
      "d /state/radicale 0750 radicale radicale -"
      "d /state/radicale/collections 0750 radicale radicale -"
    ];
  };
}

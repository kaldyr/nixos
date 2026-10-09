{
  lib,
  ...
}:
{
  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/radicale";
      user = "radicale";
      group = "radicale";
      mode = "0750";
    }
  ];

  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [ "127.0.0.1:5232" ];

      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "autodetect";
      };

      rights.type = "owner_only";
      storage.filesystem_folder = "/var/lib/radicale/collections";

      sharing = {
        type = "files";
        collection_by_map = true;
        permit_create_map = true;
        default_permissions_create_map = "rw";
      };
    };
  };

  systemd.services.radicale.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "radicale";
    Group = "radicale";
  };

  users.groups.radicale = { };

  users.users.radicale = {
    isSystemUser = true;
    group = "radicale";
  };
}

{
  config,
  ...
}:
{
  services = {
    miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets.miniflux-admin.path;

      config = {
        LISTEN_ADDR = "127.0.0.1:9003";
        BASE_URL = "https://rss.brill-godzilla.ts.net";
        CLEANUP_ARCHIVE_READ_DAYS = "-1";
        CLEANUP_ARCHIVE_UNREAD_DAYS = "-1";
      };
    };

    postgresqlBackup.databases = [ "miniflux" ];
  };

  sops.secrets.miniflux-admin = { };
}

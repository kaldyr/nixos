{
  sysConfig,
  ...
}:
{
  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/audiobookshelf";
      user = "audiobookshelf";
      group = "audiobookshelf";
      mode = "0750";
    }
  ];

  services = {
    audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = 13378;
    };

    nginx = {
      enable = true;

      virtualHosts.books-redirect =
        let
          serviceHost = service:
            if sysConfig.hostname == "magrathea" then service
            else "${sysConfig.hostname}-${service}";
        in
      {
        listen = [
          {
            addr = "127.0.0.1";
            port = 13379;
          }
        ];

        locations."/".return = "308 https://${serviceHost "books"}.brill-godzilla.ts.net/audiobookshelf";
      };
    };
  };

  users.users.audiobookshelf.extraGroups = [ "media" ];
}

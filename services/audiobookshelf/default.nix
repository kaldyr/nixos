{
  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/audiobookshelf";
      user = "audiobookshelf";
      group = "audiobookshelf";
      mode = "0750";
    }
  ];

  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 13378;
  };

  users.users.audiobookshelf.extraGroups = [ "media" ];
}

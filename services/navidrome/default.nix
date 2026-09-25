{
  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/navidrome";
      user = "navidrome";
      group = "navidrome";
      mode = "0750";
    }
  ];

  services.navidrome = {
    enable = true;

    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/storage/media/Music";
    };
  };

  users.users.navidrome.extraGroups = [ "media" ];
}

{
  environment.persistence = {
    "/state".directories = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
        mode = "0750";
      }
    ];
    "/cache".directories = [
      {
        directory = "/var/cache/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
        mode = "0750";
      }
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [
    "media"
    "render"
    "video"
  ];
}

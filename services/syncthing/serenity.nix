{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing.settings = {
    gui.insecureSkipHostcheck = true;

    # folders = {
    #
    # };
  };

  users.users.syncthing.extraGroups = [ "media" ];
}

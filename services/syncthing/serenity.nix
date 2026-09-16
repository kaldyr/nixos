{
  environment.persistence."/state".directories = [{
    directory = "/var/lib/syncthing/.config/syncthing";
    user = "syncthing";
    group = "syncthing";
    mode = "0700";
  }];

  services.syncthing.settings = {
    devices = {
      magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
    };

    # folders = {
    #
    # };

    gui.insecureSkipHostcheck = true;
  };

  users.users.syncthing.extraGroups = [ "media" ];
}

{
  services.syncthing.settings.folders = {
    matt-notes = {
      path = "/home/matt/Notes";
      devices = [ "gungnir" "magrathea" ];
    };
  };

  systemd.tmpfiles.rules = [
    "a+ /home/matt - - - - u:syncthing:x,m::x"
    "a+ /home/matt/Notes - - - - u:syncthing:rwx,m::rwx"
  ];
}

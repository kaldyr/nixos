{
  environment.persistence."/state".directories = [
    "/var/cache/cups"
    "/var/lib/cups"
    "/var/log/cups"
    "/var/spool/cups"
  ];

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    printing = {
      enable = true;
      browsed.enable = false;
    };
  };
}

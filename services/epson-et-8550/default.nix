{
  pkgs,
  ...
}:
{
  environment.persistence."/state" = {
    directories = [
      "/var/cache/cups"
      "/var/lib/cups/ppd"
      "/var/lib/cups/ssl"
      "/var/log/cups"
      "/var/spool/cups"
    ];

    files = [ "/var/lib/cups/printers.conf" ];
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr2 ];
}

{ lib, pkgs, sysConfig, ... }: {
    environment.persistence."/nix/system" = lib.mkIf sysConfig.systemImpermanence {
        directories = [
            "/var/lib/cups"
            "/var/spool/cups"
            "/var/cache/cups"
            "/var/log/cups"
        ];
    };

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.epson-escpr2 ];
}

{ pkgs, sysConfig, ... }: {
    environment = {
        persistence."/nix/system".directories = [
            {
                directory = "/var/lib/openstarbound";
                user = "starbound";
                group = "starbound";
                mode = "0775";
            }
            {
                directory = "/var/log/openstarbound";
                user = "starbound";
                group = "starbound";
                mode = "0775";
            }
        ];

        systemPackages = with pkgs; [ openstarbound ];
    };

    users = {
        groups."starbound" = { };

        users.${sysConfig.user}.extraGroups = [ "starbound" ];

        extraUsers."starbound" = {
            group = "starbound";
            home = "/var/lib/openstarbound";
            isSystemUser = true;
        };
    };
}

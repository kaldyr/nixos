{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            { directory = ".config/net.imput.helium"; mode = "0700"; }
            # { directory = ".cache/BraveSoftware"; mode = "0700"; }
            # { directory = ".config/BraveSoftware"; mode = "0700"; }
            # { directory = ".local/share/kwalletd"; mode = "0700"; }
        ];
    };

    home-manager.users.${sysConfig.user} = {
        home.packages = with pkgs; [ helium ];

        xdg.mimeApps.associations.added = {
            "applications/md" = [ "helium.desktop" ];
            "text/html" = [ "helium.desktop" ];
            "x-scheme-handler/ftp" = [ "helium.desktop" ];
            "x-scheme-handler/http" = [ "helium.desktop" ];
            "x-scheme-handler/https" = [ "helium.desktop" ];
        };
    };

}

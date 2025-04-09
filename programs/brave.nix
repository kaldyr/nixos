{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            { directory = ".cache/BraveSoftware"; mode = "0700"; }
            { directory = ".config/BraveSoftware"; mode = "0700"; }
            { directory = ".local/share/kwalletd"; mode = "0700"; }
        ];
    };

    home-manager.users.${sysConfig.user} = {
        home.packages = with pkgs; [ brave ];

        xdg.mimeApps.associations.added = {
            "applications/md" = [ "brave-browser.desktop" ];
            "text/html" = [ "brave-browser.desktop" ];
            "x-scheme-handler/ftp" = [ "brave-browser.desktop" ];
            "x-scheme-handler/http" = [ "brave-browser.desktop" ];
            "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        };
    };

}

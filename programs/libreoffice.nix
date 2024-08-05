{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [ ".config/libreoffice" ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ libreoffice ];

}

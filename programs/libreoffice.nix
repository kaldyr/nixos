{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".config/libreoffice" ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ libreoffice ];

}

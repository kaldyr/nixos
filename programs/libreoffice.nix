{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".config/libreoffice" ];

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ libreoffice ];

}

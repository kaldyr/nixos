{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/state".users.${sysConfig.user}.directories = [ ".local/share/OpenSCAD" ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ openscad ];

}

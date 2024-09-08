{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".local/share/OpenSCAD"
        ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ openscad ];

    # xdg.configFile."OpenScad/OpenSCAD.conf".text = ''
    # '';

}

{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/nix".users.${sysConfig.user}.directories = [
            { directory = ".config/obsidian"; mode = "0700"; }
        ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ obsidian ];

}

{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [
        { directory = ".config/obsidian"; mode = "0700"; }
    ];

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ obsidian ];

}

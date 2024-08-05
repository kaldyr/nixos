{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [
            ".config/BetterDiscord"
            ".config/discord"
        ];
    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ discord ];

}

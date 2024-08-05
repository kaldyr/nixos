{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [
        ".config/BetterDiscord"
        ".config/discord"
    ];

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ discord ];

}

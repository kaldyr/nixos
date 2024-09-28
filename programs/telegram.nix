{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [ ".local/share/TelegramDesktop" ];

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [ telegram-desktop ];

}

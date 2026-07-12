{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/share/TelegramDesktop" ];
    };

    environment.systemPackages = with pkgs; [ telegram-desktop ];

}

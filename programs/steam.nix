{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [ ".local/share/Steam" ];

    hardware.graphics.extraPackages32 = with pkgs; [ pkgsi686Linux.libva ];

    programs = {

        gamemode.enable = true;

        steam = {
            enable = true;
            dedicatedServer.openFirewall = true;
            remotePlay.openFirewall = true;
        };

    };

    services.pipewire.alsa.support32Bit = true;

}

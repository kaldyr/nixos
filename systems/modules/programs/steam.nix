{ pkgs, ... }: {

    environment.systemPackages = with pkgs; [ SDL2 ];

    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.opengl.setLdLibraryPath = true;

    programs = {

        gamemode.enable = true;

        steam = {
            enable = true;
            dedicatedServer.openFirewall = true;
            remotePlay.openFirewall = true;
        };

    };

}

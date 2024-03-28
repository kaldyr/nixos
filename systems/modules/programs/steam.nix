{ pkgs, ... }: {

    hardware.opengl = {

        driSupport32Bit = true;

        extraPackages = with pkgs; [
            amdvlk
            # SDL2
        ];

        extraPackages32 = with pkgs; [
            driversi686Linux.amdvlk
            pkgsi686Linux.libva
        ];

        setLdLibraryPath = true;

    };

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

{ pkgs, ... }: {

    hardware.graphics = {

        # driSupport32Bit = true;

        # extraPackages = with pkgs; [
        #     amdvlk
        # ];

        enable32Bit = true;

        extraPackages32 = with pkgs; [
            # driversi686Linux.amdvlk
            pkgsi686Linux.libva
        ];


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

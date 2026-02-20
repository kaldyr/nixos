{ pkgs, ... }: {

    environment = {

        budgie.excludePackages = with pkgs; [
            mate.atril
            mate.mate-terminal
            vlc
        ];

        systemPackages = with pkgs; [
            budgie-control-center
            budgie-desktop-with-plugins
            budgie-gsettings-overrides
            nano
        ];

    };

    programs.dconf.enable = true;

    services = {
        desktopManager.budgie.enable = true;
        displayManager = {
            autoLogin.enable = true;
            autoLogin.user = "matshkas";
            sddm.enable = true;
        };
        gvfs.enable = true;
        xserver.enable = true;
    };

}

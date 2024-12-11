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
            dconf-editor
            file-roller
            gnome-tweaks
            nano
            xclip
        ];

    };

    programs = {
        dconf.enable = true;
        thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
                thunar-archive-plugin
                thunar-media-tags-plugin
                thunar-volman
                tumbler
            ];
        };
    };

    services = {
        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = "matshkas";
        gvfs.enable = true;
        tumbler.enable = true;
        xserver.desktopManager.budgie.enable = true;
    };

}

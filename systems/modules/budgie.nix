{ pkgs, ... }: {

    environment = {

        budgie.excludePackages = with pkgs; [
            mate.atril
            mate.mate-terminal
            vlc
        ];

        systemPackages = with pkgs; [
            budgie.budgie-control-center
            budgie.budgie-desktop-with-plugins
            budgie.budgie-gsettings-overrides
            gnome.dconf-editor
            gnome.file-roller
            gnome.gnome-tweaks
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

        gvfs.enable = true;
        tumbler.enable = true;

        xserver = {
            desktopManager.budgie.enable = true;
            displayManager = {
                autoLogin.enable = true;
                autoLogin.user = "matshkas";
                lightdm.enable = true;
                lightdm.autoLogin.timeout = 0;
            };
        };

    };

}

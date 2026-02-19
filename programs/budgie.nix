{ pkgs, ... }: {

    environment = {

        budgie.excludePackages = with pkgs; [
            mate.atril
            mate.mate-terminal
        ];

        systemPackages = with pkgs; [
            budgie-control-center
            budgie-desktop-with-plugins
            budgie-gsettings-overrides
            dconf-editor
            file-roller
            gnome-tweaks
            image-roll
            nano
            xclip
        ];

    };

    programs = {
        dconf.enable = true;
        thunar = {
            enable = true;
            plugins = with pkgs; [
                thunar-archive-plugin
                thunar-media-tags-plugin
                thunar-volman
                tumbler
            ];
        };
    };

    services = {
        desktopManager.budgie.enable = true;
        displayManager = {
            autoLogin.enable = true;
            autoLogin.user = "matshkas";
            sddm.enable = true;
        };
        gvfs.enable = true;
        tumbler.enable = true;
        xserver.enable = true;
    };

}

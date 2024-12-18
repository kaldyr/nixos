{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        programs.mpv = {

            enable = true;

            scripts = with pkgs.mpvScripts; [
                modernx-zydezu
                mpris
                mpv-cheatsheet
                mpv-playlistmanager
                thumbfast
                quality-menu
            ];

        };

        xdg.configFile."mpv/input.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/mpv/input.conf";
        xdg.configFile."mpv/mpv.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/mpv/mpv.conf";

        xdg.mimeApps.associations.added = {
            "application/audio" = [ "mpv.desktop" ];
            "application/video" = [ "mpv.desktop" ];
        };

    };

}

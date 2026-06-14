{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        programs.mpv = {

            enable = true;

            scripts = with pkgs.mpvScripts; [
                modernx-zydezu
                mpris
                mpv-playlistmanager
                thumbfast
            ];

        };

        xdg.configFile."mpv".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/mpv/config";

        xdg.mimeApps.associations.added = {
            "application/audio" = [ "mpv.desktop" ];
            "application/video" = [ "mpv.desktop" ];
        };

    };

}

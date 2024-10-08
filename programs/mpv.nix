{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

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

        xdg.configFile."mpv/input.conf".text = /* bash */ ''
            f script-binding quality_menu/video_formats_toggle
            F script-binding quality_menu/audio_formats_toggle
            Ctrl+r script-binding quality_menu/reload
        '';

        xdg.configFile."mpv/mpv.conf".text = /* bash */ ''
            border = no
            gpu-api = vulkan
            hwdec = auto-safe
            osc = no
            osd-border-color = "#232634"
            osd-color = "#85c1dc"
            osd-font = Inter
            osd-font-size = 24
            osd-shadow-color = "#303446"
            profile = gpu-hq
            screenshot-directory = $HOME/Pictures/Screenshots/mpv
            vo = gpu
            volume-max = 100
            ytdl-format = bestvideo+bestaudio/best
        '';

        xdg.mimeApps.associations.added = {
            "application/audio" = [ "mpv.desktop" ];
            "application/video" = [ "mpv.desktop" ];
        };

    };

}

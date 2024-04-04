{ config, pkgs, ... }: {

    programs.mpv = {

        enable = true;

        bindings = {
            f = "script-binding quality_menu/video_formats_toggle";
            F = "script-binding quality_menu/audio_formats_toggle";
            "Ctrl+r" = "script-binding quality_menu/reload";
        };

        config = {
            border = false;
            gpu-api = "vulkan";
            hwdec = "auto-safe";
            osc = false;
            osd-border-color = "#232634";
            osd-color = "#85c1dc";
            osd-font = "IntoneMono Nerd Font";
            osd-font-size = 24;
            osd-shadow-color = "#303446";
            profile = "gpu-hq";
            screenshot-directory = "${config.xdg.userDirs.pictures}/Screenshots/mpv";
            vo = "gpu";
            volume-max = 100;
            ytdl-format = "bestvideo[height<=?480]+bestaudio/best";
        };

        scripts = with pkgs.mpvScripts; [
            modernx-zydezu
            mpris
            mpv-cheatsheet
            mpv-playlistmanager
            thumbfast
            quality-menu
        ];

    };

    xdg.mimeApps.associations.added = {
        "application/audio" = [ "mpv.desktop" ];
        "application/video" = [ "mpv.desktop" ];
    };

}

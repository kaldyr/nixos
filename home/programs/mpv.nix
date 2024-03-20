{ pkgs, ... }: {

    programs.mpv = {

        enable = true;

        config = {
            gpu-api = "vulkan";
            hwdec = "auto-safe";
            osc = false;
            profile = "gpu-hq";
            vo = "gpu";
            volume-max = 100;
        };

        scripts = with pkgs.mpvScripts; [
            mpris
            mpv-cheatsheet
            mpv-playlistmanager
        ];

    };

    xdg.mimeApps.associations.added = {
        "application/audio" = [ "mpv.desktop" ];
        "application/video" = [ "mpv.desktop" ];
    };

}

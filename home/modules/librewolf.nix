{

    programs.librewolf = {

        enable = true;

        settings = {
            "browser.compactmode.show" = true;
            "browser.startup.page" = 3;
            "extensions.unifiedExtensions.enabled" = false;
            "media.ffmpeg.vaapi.enabled" = true;
            "network.cookie.lifetimePolicy" = 0;
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.resistFingerprinting" = false;
            "webgl.disabled" = false;
        };

    };

    xdg.mimeApps.associations.added = {
        "applications/md" = [ "librewolf.desktop" ];
        "text/html" = [ "librewolf.desktop" ];
        "x-scheme-handler/ftp" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
    };

}

{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.zathura.enable = true;

        xdg.configFile."zathura/zathurarc".text = /* bash */ ''
            set completion-bg "#414559"
            set completion-fg "#C6D0F5"
            set completion-group-bg "#414559"
            set completion-group-fg "#8CAAEE"
            set completion-highlight-bg "#575268"
            set completion-highlight-fg "#C6D0F5"
            set default-bg "#303446"
            set default-fg "#C6D0F5"
            set font "Inter 12"
            set guioptions "none"
            set highlight-active-color "#F4B8E4"
            set highlight-color "#575268"
            set highlight-fg "#F4B8E4"
            set index-active-bg "#414559"
            set index-active-fg "#C6D0F5"
            set index-bg "#303446"
            set index-fg "#C6D0F5"
            set inputbar-bg "#414559"
            set inputbar-fg "#C6D0F5"
            set notification-bg "#414559"
            set notification-error-bg "#414559"
            set notification-error-fg "#E78284"
            set notification-fg "#C6D0F5"
            set notification-warning-bg "#414559"
            set notification-warning-fg "#FAE3B0"
            set recolor-darkcolor "#C6D0F5"
            set recolor-lightcolor "#303446"
            set render-loading-bg "#303446"
            set render-loading-fg "#C6D0F5"
            set selection-clipboard "clipboard"
            set statusbar-bg "#414559"
            set statusbar-fg "#C6D0F5"
        '';

        xdg.mimeApps.associations.added."application/pdf" = [ "org.pwmt.zathura.desktop" ];

    };

}

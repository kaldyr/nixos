{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.zathura = {

            enable = true;

            options = {
                font = "Inter 12";
                selection-clipboard = "clipboard";
                completion-bg = "#414559";
                completion-fg = "#C6D0F5";
                completion-group-bg = "#414559";
                completion-group-fg = "#8CAAEE";
                completion-highlight-bg = "#575268";
                completion-highlight-fg = "#C6D0F5";
                default-bg = "#303446";
                default-fg = "#C6D0F5";
                guioptions = "none";
                highlight-active-color = "#F4B8E4";
                highlight-color = "#575268";
                highlight-fg = "#F4B8E4";
                index-active-bg = "#414559";
                index-active-fg = "#C6D0F5";
                index-bg = "#303446";
                index-fg = "#C6D0F5";
                inputbar-bg = "#414559";
                inputbar-fg = "#C6D0F5";
                notification-bg = "#414559";
                notification-error-bg = "#414559";
                notification-error-fg = "#E78284";
                notification-fg = "#C6D0F5";
                notification-warning-bg = "#414559";
                notification-warning-fg = "#FAE3B0";
                recolor-darkcolor = "#C6D0F5";
                recolor-lightcolor = "#303446";
                render-loading-bg = "#303446";
                render-loading-fg = "#C6D0F5";
                statusbar-bg = "#414559";
                statusbar-fg = "#C6D0F5";
            };

        };

        xdg.mimeApps.associations.added."application/pdf" = [ "org.pwmt.zathura.desktop" ];

    };

}

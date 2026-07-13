{ sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = {
        programs.feh.enable = true;
        xdg.mimeApps.associations.added."application/image" = [ "feh.desktop" ];
    };
}

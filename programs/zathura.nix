{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.zathura.enable = true;
        xdg.configFile."zathura/zathurarc".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zathura/zathurarc";
        xdg.mimeApps.associations.added."application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };

}

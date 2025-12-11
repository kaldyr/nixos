{ lib, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".local/share/newsboat"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.newsboat.enable = true;
        xdg.configFile."newsboat/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/newsboat/config";
        xdg.configFile."newsboat/urls".source = config.lib.file.mkOutOfStoreSymlink "/home/${sysConfig.user}/Documents/feeds.rss";
    };

}

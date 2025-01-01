{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        programs.tmux.enable = true;

        xdg.configFile = {
            "tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/tmux/tmux.conf";
        };
    };

}

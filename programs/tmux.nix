{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            tmux
            yq-go
        ];

        xdg.configFile."tmux".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/tmux";

    };

}

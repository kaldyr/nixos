{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ cava ];
        xdg.configFile."cava/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/cava/config";
    };

}

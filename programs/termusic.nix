{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".config/termusic"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ termusic ];
        xdg.configFile."termusic/tui.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/termusic/tui.toml";
        xdg.configFile."termusic/server.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/termusic/server.toml";
    };

}

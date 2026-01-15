{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/state/lazygit" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        home.packages = with pkgs; [ lazygit ];
        xdg.configFile."lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/lazygit/config.yml";
    };

}

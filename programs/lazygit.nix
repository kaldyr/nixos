{ lib, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/state".users.${sysConfig.user}.directories = [ ".local/state/lazygit" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.lazygit.enable = true;
        xdg.configFile."lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/lazygit/config.yml";
    };

}

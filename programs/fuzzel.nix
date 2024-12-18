{ lib, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.files = [ ".cache/fuzzel" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.fuzzel.enable = true;
        xdg.configFile."fuzzel/fuzzel.ini".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/fuzzel/fuzzel.ini";
    };

}

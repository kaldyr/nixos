{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".local/state/qalculate"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ libqalculate ];

        xdg.configFile."qalculate/qalc.cfg".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/qalculate/qalc.cfg";

    };

}

{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.files = [ ".cache/zellij/permissions.kdl" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        programs.zellij.enable = true;

        xdg.configFile = {
            "zellij/plugins/zjframes.wasm".source = pkgs.fetchurl {
                url = "https://github.com/dj95/zjstatus/releases/download/v0.19.2/zjframes.wasm";
                sha256 = "sha256-pNAVZHdIVK3k0XHinxeDpR30P0KWkxZUSd6QfNc5a0k=";
            };
            "zellij/plugins/zjpane.wasm".source = pkgs.fetchurl {
                url = "https://github.com/FuriouZz/zjpane/releases/download/v0.2.0/zjpane.wasm";
                sha256 = "sha256-N2u0nPY//EpnJ6YoFGgoS7taL3S/SxfrE2qKfgywqt4=";
            };
            "zellij/plugins/zjstatus.wasm".source = pkgs.fetchurl {
                url = "https://github.com/dj95/zjstatus/releases/download/v0.19.2/zjstatus.wasm";
                sha256 = "sha256-Jp3l3HLQxN1Jd4jyJPD7ICO/1heItMFfETDjrUsOqeI=";
            };
            "zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/config.kdl";
            "zellij/layouts/default.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/layouts/default.kdl";
            "zellij/layouts/dev.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/layouts/dev.kdl";
        };
    };

}

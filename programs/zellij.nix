{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.files = [ ".cache/zellij/permissions.kdl" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ zellijPlugins.zjstatus ];

        programs.zellij.enable = true;

        xdg.configFile = {
            "zellij/plugins/zjstatus.wasm".source = "${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm";
            "zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/config.kdl";
            "zellij/layouts/default.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/layouts/default.kdl";
            "zellij/layouts/dev.kdl".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/zellij/layouts/dev.kdl";
        };
    };

}

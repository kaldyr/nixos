{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user} = {
            directories = [ ".config/helix/runtime" ];
            files = [ ".cache/helix/helix.log" ];
        };
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            gopls
            htmx-lsp
            lua-language-server
            marksman
            nil
            taplo
            yaml-language-server
            vscode-langservers-extracted
        ];

        programs.helix.enable = true;

        xdg.configFile = {
            "helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/helix/config.toml";
            "helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/helix/languages.toml";
        };

    };

}

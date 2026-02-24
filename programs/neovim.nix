{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/nvim"
            ".local/share/nvim"
            ".local/state/nvim"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.file.".local/share/nvim/grammars".source = pkgs.symlinkJoin {
            name = "nvim-treesitter-grammars";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };

        home.packages = with pkgs; [
            neovim
            # System utilities
            fzf
            gcc
            git
            gnumake
            # Language servers
            gopls
            htmx-lsp
            lua-language-server
            marksman
            nixd
            taplo
            yaml-language-server
            vscode-langservers-extracted
            # Extras
            python312Packages.pylatexenc
        ];

        xdg.configFile."nvim/lsp".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/lsp";
        xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/lua";
        xdg.configFile."nvim/queries".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/queries";
        xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/init.lua";
        xdg.configFile."nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/${sysConfig.hostname}-lock.json";
        xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

    };

}

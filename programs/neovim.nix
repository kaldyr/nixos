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
            fd
            fzf
            gcc
            git
            gnumake
            ripgrep
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

        xdg = {
            configFile = {
                "nvim/lsp".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/lsp";
                "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/lua";
                "nvim/queries".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/queries";
                "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/init.lua";
                "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/nvim/${sysConfig.hostname}-lock.json";
            };
            # desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };
            mimeApps.associations.added."text/plain" = [ "nvim.desktop" ];
        };

    };

}

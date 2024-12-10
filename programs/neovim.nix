{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/nvim" ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            neovim
            # System utilities
            fd
            fzf
            git
            ripgrep
            # Language servers
            gopls
            htmx-lsp
            lua-language-server
            marksman
            nil
            taplo
            yaml-language-server
            vscode-langservers-extracted
            # Extras
            python312Packages.pylatexenc
        ];

        xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

    };

}

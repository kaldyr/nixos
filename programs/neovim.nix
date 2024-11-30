{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/nvim" ];

    home-manager.users.${sysConfig.user} = {

        programs.neovim.enable = true;

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

        xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

    };

}

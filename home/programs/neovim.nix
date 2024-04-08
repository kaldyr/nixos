{ inputs, pkgs, ... }: {

    home = {

        packages = with pkgs; [
            lua-language-server
            marksman
            nil
        ] ++ [ inputs.neovim.packages.${pkgs.system}.default ];

    };

    xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

}

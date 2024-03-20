{ inputs, pkgs, ... }: {

    home = {

        packages = with pkgs; [
            lua-language-server
            marksman
            nil
        ] ++ [ inputs.neovim.packages.${pkgs.system}.default ];

        sessionVariables.EDITOR = "nvim";
        sessionVariables.VISUAL = "nvim";

    };

    xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

}

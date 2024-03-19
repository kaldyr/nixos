{ inputs, pkgs, ... }: {

    home = {

        packages = [
            inputs.neovim.packages.${pkgs.system}.default
        ] ++ (with pkgs; [
            lua-language-server
            marksman
            nil
        ]);

        sessionVariables.EDITOR = "nvim";
        sessionVariables.VISUAL = "nvim";

    };

    xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

}

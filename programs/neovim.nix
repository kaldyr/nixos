{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/nvim" ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            lua-language-server
            marksman
            neovim
            nil
        ];

        xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

    };

}

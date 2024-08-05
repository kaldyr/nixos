{ inputs, lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [ ".local/state/nvim" ];
    };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            lua-language-server
            marksman
            nil
        ] ++ [ inputs.neovim.packages.${pkgs.system}.default ];

        xdg.desktopEntries.nvim = { name = "Neovim Wrapper"; noDisplay = true; };

    };

}

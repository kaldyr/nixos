{ inputs, sysConfig, ...}: {

    imports = [
        ../programs/bat.nix
        ../programs/btop.nix
        ../programs/eza.nix
        ../programs/fish.nix
        ../programs/fzf.nix
        ../programs/git.nix
        ../programs/lazygit.nix
        ../programs/neovim.nix
        ../programs/starship.nix
        ../programs/yazi.nix
        ../programs/zellij.nix
        ../programs/zoxide.nix
    ];

    home-manager = {

        extraSpecialArgs = { inherit inputs sysConfig; };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${sysConfig.user} = {

            home = {
                homeDirectory = "/home/${sysConfig.user}";
                stateVersion = sysConfig.instalVersion;
                username = sysConfig.user;
            };

            programs.home-manager.enable = true;

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";

            xdg.enable = true;

        };

    };

}

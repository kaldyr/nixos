{ inputs, pkgs, sysConfig, ... }: {

    home-manager = {

        extraSpecialArgs = { inherit inputs sysConfig; };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${sysConfig.user} = {

            home = {
                username = sysConfig.user;
                homeDirectory = "/home/${sysConfig.user}";
                packages = with pkgs; [
                    age
                    bc
                    duf
                    fd
                    gdu
                    jq
                    ripgrep
                    sops
                    ssh-to-age
                ];
                stateVersion = sysConfig.instalVersion;
            };

            imports = [
                ./programs/bat.nix
                ./programs/btop.nix
                ./programs/eza.nix
                ./programs/fish.nix
                ./programs/fzf.nix
                ./programs/git.nix
                ./programs/lazygit.nix
                ./programs/neovim.nix
                ./programs/starship.nix
                ./programs/yazi.nix
                ./programs/zellij.nix
                ./programs/zoxide.nix
            ] ++ sysConfig.extraHomeModules;

            programs.home-manager.enable = true;

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";

            xdg.enable = true;

        };

    };

}

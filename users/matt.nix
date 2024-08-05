{ config, inputs, pkgs, sysConfig, ...}: {

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
                sessionVariables.EDITOR = "nvim";
                sessionVariables.VISUAL = "nvim";
                username = sysConfig.user;

            };

            programs.home-manager.enable = true;

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";

            xdg.enable = true;

        };

    };


    programs.fish.enable = true;
    programs.nano.enable = false;

    sops.secrets.matt-password.neededForUsers = true;

    users = {

        mutableUsers = false;

        users.${sysConfig.user} = {

            description = "Matt";
            extraGroups = [ "wheel" "networkmanager" "video" ];
            hashedPasswordFile = config.sops.secrets.matt-password.path;
            isNormalUser = true;

            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvQpANtgx4Zfpeyn9JcQUthOdqkemkrbVF+0fSa8Fbz matt@gram"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEI16mw0+rV583qqsxv0zjEUfGgcwXczuOYFjWrDYmg matt@magrathea"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
            ];

            shell = pkgs.fish;

        };

    };

}

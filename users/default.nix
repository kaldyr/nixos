{ inputs, lib, pkgs, sysConfig, ...}: {

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

    environment.persistence = lib.mkIf sysConfig.impermanence {

        # Home files that aren't declarative and need to be preserved
        # Snapshots will back up state
        "/state" = {

            hideMounts = true;

            users.${sysConfig.user} = {
                directories = [
                    { directory = ".config/sops/age"; mode = "0700"; }
                    { directory = ".gnupg"; mode = "0700"; }
                    { directory = ".local/share/keyrings"; mode = "0700"; }
                    { directory = ".ssh"; mode = "0700"; }
                ];
            };

        };

        # Home files that need to be preserved between boots
        #  These files do not need to be backed up
        # Syncthing and Nextcloud handle the personal files
        "/nix" = {

            hideMounts = true;

            users.${sysConfig.user} = {
                directories = [
                    ".local/share/applications"
                    "Audiobooks"
                    "Books"
                    "Documents"
                    "Downloads"
                    "Music"
                    "Notes"
                    "Pictures"
                    "Projects"
                    "Videos"
                ];
            };

        };

    };

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
                username = sysConfig.user;

            };

            programs.home-manager.enable = true;

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";

            xdg.enable = true;

        };

    };

}

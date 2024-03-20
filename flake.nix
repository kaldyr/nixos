{

    inputs = {

        # Set nixpkgs to NixOS Unstable
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

        # Disko - Declarative partition management
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        # Impermanence - come back to truth at every boot
        impermanence.url = "github:nix-community/impermanence";

        # Sops - secret management
        sops-nix.url = "github:Mic92/sops-nix";

        # Manage the home folder and user applications
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Custom Neovim
        neovim.url = "github:kaldyr/neovim";

    };

    outputs = { disko, home-manager, impermanence, neovim, nixpkgs, sops-nix, ... }@inputs: {

        nixosConfigurations = let 

            buildSystem = sysConfig: nixpkgs.lib.nixosSystem {

                system = sysConfig.arch;
                specialArgs = { inherit inputs sysConfig; };

                modules = [

                    # Load in Modules from Libraries
                    disko.nixosModules.disko
                    impermanence.nixosModules.impermanence
                    sops-nix.nixosModules.sops
                    
                    # System configs
                    { system.stateVersion = sysConfig.instalVersion; }
                    ./systems/default.nix               # Common to all machines
                    ./systems/${sysConfig.hostname}.nix # Specific for this machine
                    ./users/${sysConfig.user}.nix       # User definition

                    # Manage those user dots
                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            extraSpecialArgs = { inherit inputs sysConfig; };
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.${sysConfig.user} = {
                                home = {
                                    username = sysConfig.user;
                                    homeDirectory = "/home/${sysConfig.user}";
                                    stateVersion = sysConfig.instalVersion;
                                };
                                imports = [ ./home ] ++ sysConfig.extraHomeModules;
                            };
                        };
                    }

                ];

            };

        in {

            # Espresso: Ryzen 5700g Desktop
            # "espresso" = let
            #     sysConfig = {
            #         arch = "x86_64-linux";
            #         hostname = "espresso";
            #         instalVersion = ""; # Update this only on a fresh format/install
            #         user = "matshkas";
            #         extraHomeModules = [
            #             ./home/desktop.nix
            #             ./home/budgie.nix
            #         ];
            #     };
            # in buildSystem ( sysConfig );

            # Hofud: Dell Inspiron 7425 Shared Laptop
            "hofud" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "hofud";
                    instalVersion = "24.05"; # Update this only on a fresh format/install
                    user = "matt";
                    extraHomeModules = [
                        ./home/desktop.nix
                        ./home/hyprland.nix
                        ./home/modules/firefox.nix
                        ./home/modules/librewolf.nix
                        ./home/modules/mpd.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Installer: Custom ISO image for installing NixOS
            "installer" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "installer";
                    instalVersion = "24.05"; # Update this only on a fresh format/install
                    user = "nixos";
                    extraHomeModules = [
                        ./home/desktop.nix
                        ./home/hyprland.nix
                        ./home/modules/librewolf.nix
                    ];
                };
            in buildSystem ( sysConfig );
                

            # Magrathea: Intel i5-2500k Nextcloud server with Kodi and media storage
            "magrathea" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "magrathea";
                    instalVersion = "24.05"; # Update this only on a fresh format/install
                    user = "matt";
                    extraHomeModules = [ ];
                };
            in buildSystem ( sysConfig );

            # Mjolnir: MinisForum UM790 Pro - Desktop
            "mjolnir" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "mjolnir";
                    instalVersion = "23.05"; # Update this only on a fresh format/install
                    user = "matt";
                    extraHomeModules = [
                        ./home/desktop.nix
                        ./home/hyprland.nix
                        ./home/modules/firefox.nix
                        ./home/modules/librewolf.nix
                        ./home/modules/mpd.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Oolong: Dell Inspiron (Get Model Number)
            # "oolong" = let
            #     sysConfig = {
            #         arch = "x86_64-linux";
            #         hostname = "oolong";
            #         instalVersion = ""; # Update this only on a fresh format/install
            #         user = "matshkas";
            #         extraHomeModules = [
            #             ./home/desktop.nix
            #             ./home/budgie.nix
            #         ];
            #     };
            # in buildSystem ( sysConfig );

            # Serenity: Ryzen 5 2500g Kodi with media storage and off-site backup of snapshots
            # "serenity" = let
            #     sysConfig = {
            #         arch = "x86_64-linux";
            #         hostname = "serenity";
            #         instalVersion = ""; # Update this only on a fresh format/install
            #         user = "matt";
            #         extraHomeModules = [ ];
            #     };
            # in buildSystem ( sysConfig );

        };

    };

}

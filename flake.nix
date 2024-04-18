{

    inputs = {

        # Set nixpkgs to NixOS Unstable
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # NixOS Hardware
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    outputs = { disko
              , home-manager
              , impermanence
              , neovim
              , nixos-hardware
              , nixpkgs
              , sops-nix
              , ... }@inputs: {

        nixosConfigurations = let 

            overlays = import ./overlays.nix { inherit inputs; };

            buildSystem = sysConfig: nixpkgs.lib.nixosSystem {

                system = sysConfig.arch;
                specialArgs = { inherit inputs sysConfig; };

                modules = [

                    # Load overlays
                    { nixpkgs.overlays = with overlays; [ modifications ]; }

                    # Load in Modules from Libraries
                    disko.nixosModules.disko
                    home-manager.nixosModules.home-manager
                    impermanence.nixosModules.impermanence
                    sops-nix.nixosModules.sops

                    # Configurations
                    ./systems/${sysConfig.hostname}.nix # Specific for this machine
                    ./users/${sysConfig.user}.nix       # User config

                ];

            };

        in {

            # Espresso: Ryzen 5700g Desktop
            "espresso" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "espresso";
                    instalVersion = ""; 
                    user = "matshkas";
                    extraHomeModules = [
                        ./home/programs/floorp.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Gram: Dell Inspiron 3185
            "gram" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "gram";
                    instalVersion = "24.05"; 
                    user = "matt";
                    extraHomeModules = [
                        ./home/hyprland.nix
                        ./home/programs/librewolf.nix
                        ./home/programs/mpd.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Hofud: Dell Inspiron 7425 Shared Laptop
            "hofud" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "hofud";
                    instalVersion = "24.05"; 
                    user = "matt";
                    extraHomeModules = [
                        ./home/hyprland.nix
                        ./home/programs/librewolf.nix
                        ./home/programs/mpd.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Installer: Custom ISO image for installing NixOS
            "installer" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "installer";
                    instalVersion = "24.05"; 
                    user = "nixos";
                    extraHomeModules = [
                        ./home/hyprland.nix
                        ./home/programs/librewolf.nix
                    ];
                };
            in buildSystem ( sysConfig );
                
            # Magrathea: Intel i5-2500k Nextcloud server with Kodi and media storage
            "magrathea" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "magrathea";
                    instalVersion = "24.05"; 
                    user = "matt";
                    extraHomeModules = [ ];
                };
            in buildSystem ( sysConfig );

            # Mjolnir: MinisForum UM790 Pro - Desktop
            "mjolnir" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "mjolnir";
                    instalVersion = "23.05"; 
                    user = "matt";
                    extraHomeModules = [
                        ./home/hyprland.nix
                        ./home/programs/librewolf.nix
                        ./home/programs/mpd.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Oolong: Dell Inspiron (Get Model Number)
            "oolong" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "oolong";
                    instalVersion = ""; 
                    user = "matshkas";
                    extraHomeModules = [
                        ./home/programs/floorp.nix
                    ];
                };
            in buildSystem ( sysConfig );

            # Serenity: Ryzen 5 2400g Kodi with media storage and off-site backup of snapshots
            "serenity" = let
                sysConfig = {
                    arch = "x86_64-linux";
                    hostname = "serenity";
                    instalVersion = ""; 
                    user = "matt";
                    extraHomeModules = [ ];
                };
            in buildSystem ( sysConfig );

        };

    };

}

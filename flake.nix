{

    inputs = {

        # Disko - Declarative partition management
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        # Manage the home folder and user applications
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Impermanence - come back to truth at every boot
        impermanence.url = "github:nix-community/impermanence";

        # Custom Neovim
        neovim.url = "github:kaldyr/neovim";
        neovim.inputs.nixpkgs.follows = "nixpkgs";

        # NixOS Hardware
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        # Nixpkgs
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-exiftool.url = "github:NixOS/nixpkgs/0dfa68647420b93080a04508dda41476cccc0cd0";

        # Sops - secret management
        sops-nix.url = "github:Mic92/sops-nix";
        sops-nix.inputs.nixpkgs.follows = "nixpkgs";

        # Wezterm
        wezterm.url = "github:wez/wezterm?dir=nix";

        # Zellij status plugin
        zjstatus.url = "github:dj95/zjstatus";
        zjstatus.inputs.nixpkgs.follows = "nixpkgs";

    };

    outputs = { nixpkgs, ... }@inputs: {

        nixosConfigurations = let

            overlays = import ./overlays.nix { inherit inputs; };

            buildSystem = sysConfig: nixpkgs.lib.nixosSystem {

                system = "x86_64-linux";
                specialArgs = { inherit inputs sysConfig; };

                modules = [

                    # Load overlays
                    { nixpkgs.overlays = with overlays; [ additions modifications ]; }

                    # Load in Modules from Libraries
                    inputs.disko.nixosModules.disko
                    inputs.home-manager.nixosModules.home-manager
                    inputs.impermanence.nixosModules.impermanence
                    inputs.sops-nix.nixosModules.sops

                    # User config
                    ./users/default.nix # Defaults for all users
                    ./users/${sysConfig.user}.nix # Specific user configuration

                    # System Config
                    ./systems/default.nix # Defaults for all systems
                    ./systems/${sysConfig.hostname}.nix # Specific for this machine

                ];

            };

        in {

            # Espresso: Desktop 5700g
            "espresso" = let
                sysConfig = {
                    hostname = "espresso";
                    instalVersion = "24.11";
                    user = "matshkas";
                    homeImpermanence = false;
                };
            in buildSystem ( sysConfig );

            # Gram: Framework 11th Gen i5-1135G7
            "gram" = let
                sysConfig = {
                    hostname = "gram";
                    instalVersion = "24.05";
                    user = "matt";
                    homeImpermanence = true;
                };
            in buildSystem ( sysConfig );

            # Magrathea: Intel i5-2500K Nextcloud server with Kodi, media storage, and snapshot backups
            "magrathea" = let
                sysConfig = {
                    hostname = "magrathea";
                    instalVersion = "24.05";
                    user = "matt";
                    homeImpermanence = true;
                };
            in buildSystem ( sysConfig );

            # Mjolnir: MinisForum UM790 Pro
            "mjolnir" = let
                sysConfig = {
                    hostname = "mjolnir";
                    instalVersion = "23.05";
                    user = "matt";
                    homeImpermanence = true;
                };
            in buildSystem ( sysConfig );

            # Oolong: Laptop
            "oolong" = let
                sysConfig = {
                    hostname = "oolong";
                    instalVersion = "24.05";
                    user = "matshkas";
                    homeImpermanence = false;
                };
            in buildSystem ( sysConfig );

            # Serenity: Ryzen 5 2400g Kodi, media storage, and off-site snapshot backups
            "serenity" = let
               sysConfig = {
                   hostname = "serenity";
                   instalVersion = "";
                   user = "matt";
                    homeImpermanence = true;
               };
            in buildSystem ( sysConfig );

        };

    };

}

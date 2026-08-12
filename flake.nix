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

    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Sops - secret management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Helium Browser
    #  Can remove when it becomes available in nixpkgs.
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # Yazi file manager
    #  Locked 2026-08-07 for Drag & Drop support.
    #  Remove when merged into a release and nixpkgs has new version.
    yazi.url = "github:sxyazi/yazi/f42a0df4df829b3c774e8f6dd03e10353269a23b";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations =
        let
          overlays = import ./overlays.nix { inherit inputs; };

          buildSystem =
            sysConfig:
            nixpkgs.lib.nixosSystem {
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
        in
        {
          # Espresso: MinisForum UM790 Pro
          "espresso" =
            let
              sysConfig = {
                hostname = "espresso";
                stateVersion = "26.05"; # Fresh install July 14th, 2026
                user = "matshkas";
                systemImpermanence = true;
                homeImpermanence = false;
              };
            in
            buildSystem sysConfig;

          # Hofud: Framework 13 11th gen Intel i5-1135G7
          # "hofud" =
          #   let
          #     sysConfig = {
          #       hostname = "hofud";
          #       stateVersion = ""; # In Limbo, waiting on parts
          #       user = "";
          #       systemImpermanence = true;
          #       homeImpermanence = true;
          #     };
          #   in
          #   buildSystem sysConfig;

          # Magrathea: Intel i5-2500K Nextcloud server with Kodi, media storage, and snapshot backups
          "magrathea" =
            let
              sysConfig = {
                hostname = "magrathea";
                stateVersion = "24.05";
                user = "matt";
                systemImpermanence = true;
                homeImpermanence = true;
              };
            in
            buildSystem sysConfig;

          # Mjolnir: Framework 13 Core Ultra Series 3 x7 358H
          "mjolnir" =
            let
              sysConfig = {
                hostname = "mjolnir";
                stateVersion = "26.05"; # Fresh install July 16th, 2026
                user = "matt";
                systemImpermanence = true;
                homeImpermanence = true;
              };
            in
            buildSystem sysConfig;

          # Normandy: Ryzen 3700X RX 7600 Desktop
          "normandy" =
            let
              sysConfig = {
                hostname = "normandy";
                stateVersion = "26.05"; # Fresh install
                user = "nic";
                systemImpermanence = true;
                homeImpermanence = false;
              };
            in
            buildSystem sysConfig;

          # Oolong: Dell Inspiron 14 3473 - 4GB RAM, 32GB SSD
          "oolong" =
            let
              sysConfig = {
                hostname = "oolong";
                stateVersion = "24.11"; # Fresh install on December 17th, 2024
                user = "matshkas";
                systemImpermanence = false;
                homeImpermanence = false;
              };
            in
            buildSystem sysConfig;

          # Serenity: Ryzen 5 2400g Kodi, media storage, and off-site snapshot backups
          # "serenity" =
          #   let
          #     sysConfig = {
          #       hostname = "serenity";
          #       stateVersion = ""; # Haven't installed yet
          #       user = "matt";
          #       systemImpermanence = true;
          #       homeImpermanence = true;
          #     };
          #   in
          #   buildSystem sysConfig;
        };
    };
}

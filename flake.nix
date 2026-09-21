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

    # Chroncal
    chroncal.url = "github:DouglasdeMoura/chroncal";
    chroncal.inputs.nixpkgs.follows = "nixpkgs";

    # Helium Browser
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }@inputs:
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
          "aziraphale" =
            let
              sysConfig = {
                hostname = "aziraphale";
                user = "janice";
                stateVersion = "26.11";
              };
            in
            buildSystem sysConfig;

          "espresso" =
            let
              sysConfig = {
                hostname = "espresso";
                user = "matshkas";
                stateVersion = "26.05";
              };
            in
            buildSystem sysConfig;

          "installer" =
            let
              sysConfig = {
                hostname = "installer";
                user = "matt";
                stateVersion = "26.11";
              };
            in
            buildSystem sysConfig;

          "magrathea" =
            let
              sysConfig = {
                hostname = "magrathea";
                user = "matt";
                stateVersion = "24.05";
              };
            in
            buildSystem sysConfig;

          "mjolnir" =
            let
              sysConfig = {
                hostname = "mjolnir";
                user = "matt";
                stateVersion = "26.05";
              };
            in
            buildSystem sysConfig;

          "normandy" =
            let
              sysConfig = {
                hostname = "normandy";
                user = "nic";
                stateVersion = "26.11";
              };
            in
            buildSystem sysConfig;

          "serenity" =
            let
              sysConfig = {
                hostname = "serenity";
                user = "matt";
                stateVersion = "26.11";
              };
            in
            buildSystem sysConfig;
        };
    };
}

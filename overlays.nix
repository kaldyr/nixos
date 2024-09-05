{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {

        # Update to xdg-desktop-portal-hyprland fixes build error in Hyprland
        xdg-desktop-portal-hyprland = inputs.nixpkgs-fresh.legacyPackages.${prev.system}.xdg-desktop-portal-hyprland;

    };

}

{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {
        nextcloud29 = inputs.nixpkgs-fresh.legacyPackages.${prev.system}.nextcloud29;
    };

}

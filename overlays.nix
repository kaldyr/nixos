{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {
        # PACKAGE = inputs.nixpkgs-fresh.legacyPackages.${prev.system}.PACKAGE;
    };

}

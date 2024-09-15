{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {
        final.pkgs.nextcloud29= inputs.nixpkgs-fresh.pkgs.nextcloud29;
    };

}

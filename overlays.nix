{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {
        final.pkgs.nextcloud.package = inputs.nixpkgs-fresh.pkgs.nextcloud;
    };

}

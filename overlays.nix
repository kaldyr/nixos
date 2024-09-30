{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.system}.PACKAGE;

        neovim = inputs.neovim.packages.${prev.system}.default;
        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.system}.exiftool;

    };

}

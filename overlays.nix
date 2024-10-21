{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.system}.PACKAGE;

        neovim = inputs.neovim.packages.${prev.system}.default;
        nextcloud30 = inputs.nixpkgs-fresh.legacyPackages.${prev.system}.nextcloud30;
        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.system}.exiftool;

    };

}

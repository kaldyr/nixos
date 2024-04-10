{ inputs, ... }: {

    # additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = final: prev: {

        electron = inputs.nixpkgs-electron-fix.legacyPackages.${final.system}.electron;
        electron_28 = inputs.nixpkgs-electron-fix.legacyPackages.${final.system}.electron_28;

    };

}

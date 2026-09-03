{ inputs, ... }: {
  additions = final: _prev: import ./pkgs final.pkgs;

  modifications = final: prev: {
    chroncal = inputs.chroncal.packages.${prev.stdenv.hostPlatform.system}.default;
    helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}

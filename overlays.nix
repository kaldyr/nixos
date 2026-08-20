{ inputs, ... }: {
  additions = final: _prev: import ./pkgs final.pkgs;

  modifications = final: prev: {
    helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}

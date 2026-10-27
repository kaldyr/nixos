{ inputs, ... }: {
  additions = final: _prev: import ./pkgs final.pkgs;

  modifications = final: prev: {
    disko = inputs.disko.packages.${prev.stdenv.hostPlatform.system}.default;
    helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.helium-widevine;
    openstarbound = inputs.openstarbound.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}

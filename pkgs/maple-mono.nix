{ lib, pkgs }: pkgs.stdenv.mkDerivation rec {

    pname = "MapleMono-NF-unhinted";
    version = "7.9";
    src = pkgs.fetchurl {
        url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
        sha256 = "sha256-gkjWJgZgvhBmtevpDSUTFYLfg4PzjbHChN0fLcnStG4=";
    };

    # Work around the "unpacker appears to have produced no directories"
    # case that happens when the archive doesn't have a subdirectory.
    sourceRoot = ".";
    nativeBuildInputs = [ pkgs.unzip ];
    installPhase = ''
        find . -name '*.ttf' -exec install -Dt $out/share/fonts/truetype {} \;
    '';

    meta = with lib; {
        homepage = "https://github.com/subframe7536/Maple-font";
        description = ''
            Open source Nerd Font (Unhinted) font with round corner and ligatures for IDE and command line
        '';
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ kaldyr ];
    };

}

{ lib, pkgs, }: let

    config = builtins.toFile "config.yaml" ''
        Family Name: Custom

        Fonts:
            Regular:
                MONO: 1
                CASL: 1
                wght: 425
                slnt: 0
                CRSV: 0
            Italic:
                MONO: 1
                CASL: 1
                wght: 425
                slnt: -15
                CRSV: 1
            Bold:
                MONO: 1
                CASL: 1
                wght: 800
                slnt: 0
                CRSV: 0
            Bold Italic:
                MONO: 1
                CASL: 1
                wght: 800
                slnt: -15
                CRSV: 1

        Code Ligatures: False

        Features:
        - case
        - ss01
        - ss02
        - ss03
        - ss04
        - ss05
        - ss06
        - ss07
        - ss08
        - ss09
        - ss10
        - ss11
        - ss12
        - titl
    '';

    pythonEnv = pkgs.python3.withPackages (ps:
        with ps;
        [ skia-pathops pyyaml ] ++ [
            (pkgs.python3.pkgs.buildPythonPackage rec {
                pname = "font-v";
                version = "2.1.0";
                src = pkgs.python3.pkgs.fetchPypi {
                    inherit pname version;
                    sha256 = "1l5xcs2f6jh1p3zl8knfixyh5qgkchipjb2h6d3g1pd70h3clzaw";
                };
                propagatedBuildInputs = with pkgs.python3.pkgs; [ fonttools gitpython ];
            })
            (pkgs.python3.pkgs.buildPythonPackage rec {
                pname = "ttfautohint-py";
                version = "0.5.1";
                src = pkgs.python3.pkgs.fetchPypi {
                    inherit pname version;
                    sha256 = "1yllzbsq18y3l5sq7z7fa78klp93ngw6iszzs8zap6bk8ghj9qym";
                };
                buildInputs = [ pkgs.python3.pkgs.setuptools-scm ];
            })
            (pkgs.python3.pkgs.buildPythonPackage rec {
                pname = "opentype-feature-freezer";
                version = "1.32.2";
                src = pkgs.python3.pkgs.fetchPypi {
                    inherit pname version;
                    sha256 = "0wxmqbf6lrkkjsvg2ck5v304fbyq31b2nvs7ala2ykpfpwh37jfd";
                };
                propagatedBuildInputs = [ pkgs.python3.pkgs.fonttools ];
            })
        ]);

    ligaturizer = pkgs.fetchFromGitHub {
        owner = "ToxicFrog";
        repo = "Ligaturizer";
        rev = "v5";
        sha256 = "sha256-sFzoUvA4DB9CVonW/OZWWpwP0R4So6YlAQeqe7HLq50=";
        fetchSubmodules = true;
    };

in pkgs.stdenv.mkDerivation {

    pname = "recursive-mono-custom";
    version = "1.085";

    src = pkgs.fetchFromGitHub {
        owner = "arrowtype";
        repo = "recursive-code-config";
        rev = "b6075af2603818dee5b0a71ea1780d039b42d4e2";
        hash = "sha256-kq6IEz9HpomyWtrY6tqb+EYwhOEypWL3wYAMdZ97rDc=";
    };

    buildPhase = /* bash */ ''
        export LD_LIBRARY_PATH="${pkgs.ttfautohint}/lib:LD_LIBRARY_PATH"

        mkdir nix-output

        ${pythonEnv}/bin/python \
        scripts/instantiate-code-fonts.py ${config}
        buildFolder=''${PWD}
        pushd ${ligaturizer}
        find ''${buildFolder}/fonts/RecMonoCustom \
            -name "*.ttf" \
            -exec ${pkgs.fontforge}/bin/fontforge \
            -lang py \
            -script ligaturize.py {} \
            --output-dir=''${buildFolder}/nix-output \;
        popd
    '';

    installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp ./nix-output/*.ttf $out/share/fonts/truetype
    '';

    meta = {
        changelog = "https://github.com/arrowtype/recursive-code-config/blob/main/README.md";
        description = "Custom build for Recursive font";
        homepage = "https://github.com/arrowtype/recursive-code-config";
        license = lib.licenses.mit;
        mainProgram = "recursive-mono-custom";
        maintainers = with lib.maintainers; [ kaldyr ];
        platforms = lib.platforms.linux;
    };

}

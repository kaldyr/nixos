{

    fixes = final: prev: {

        # Catppuccin-gtk is failing to build right now, this overlay gets the correct version of python
        # Remove when cattpuccin-gtk is updated to use the latest python version
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ (

            python-final: python-prev: {
                catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
                    version = "1.3.2";

                    src = prev.fetchFromGitHub {
                        owner = "catppuccin";
                        repo = "python";
                        rev = "refs/tags/v${version}";
                        hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
                    };

                    # can be removed next version
                    disabledTestPaths = [
                        "tests/test_flavour.py" # would download a json to check correctness of flavours
                    ];
                });
            }

        ) ];
    };
}

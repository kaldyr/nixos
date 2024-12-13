{ lib, pkgs, }:

pkgs.buildGoModule rec {

    pname = "lazysql";
    version = "0.3.2";

    src = pkgs.fetchFromGitHub {
        owner = "jorgerojas26";
        repo = "lazysql";
        rev = "v${version}";
        hash = "sha256-W07C5EqBz+PgtRTJPGmuvoO8wf9t0RWi1toQzeyAq2I=";
    };

    vendorHash = "sha256-HPfk9jWNwL4C4CIrh5IJrA9v+EhaWba+lbZbIuERpkU=";

    meta = with lib; {
        description = "A cross-platform TUI database management tool written in Go";
        homepage = "https://github.com/jorgerojas26/lazysql";
        license = licenses.mit;
        maintainers = with maintainers; [ kaldyr ];
        mainProgram = "lazysql";
    };

}

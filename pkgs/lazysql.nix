{ lib, pkgs, }:

pkgs.buildGoModule rec {

    pname = "lazysql";
    version = "0.3.3";

    src = pkgs.fetchFromGitHub {
        owner = "jorgerojas26";
        repo = "lazysql";
        rev = "v${version}";
        hash = "sha256-+7KchZbd/XJ+c5ndA4arbKabeMxX1ZTOVs7Nw+TSxGI=";
    };

    vendorHash = "sha256-ef3GngaaoNEJAOF5IlTQhTrO5P22w5p7G91TYJasfGk=";

    meta = with lib; {
        description = "A cross-platform TUI database management tool written in Go";
        homepage = "https://github.com/jorgerojas26/lazysql";
        license = licenses.mit;
        maintainers = with maintainers; [ kaldyr ];
        mainProgram = "lazysql";
    };

}

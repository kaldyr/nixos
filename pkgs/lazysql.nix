{ lib, pkgs, }:

pkgs.buildGoModule rec {

	pname = "lazysql";
	version = "0.3.1";

	src = pkgs.fetchFromGitHub {
		owner = "jorgerojas26";
		repo = "lazysql";
		rev = "v${version}";
		hash = "sha256-BdFNqzKXOUI9EYR0kKN/QWwKtq+iOEHKq9yexkmXTb8=";
	};

	vendorHash = "sha256-SKNFViwoMzZ1hKKZSvTm0/kKro1IaUVsC+0Pbv7FoAU=";

	meta = with lib; {
		description = "A cross-platform TUI database management tool written in Go";
		homepage = "https://github.com/jorgerojas26/lazysql";
		license = licenses.mit;
		maintainers = with maintainers; [ kaldyr ];
		mainProgram = "lazysql";
	};

}

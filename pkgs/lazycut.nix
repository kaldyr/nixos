{ pkgs, ... }: pkgs.buildGoModule rec {

    pname = "lazycut";
    version = "0.3.9";

    buildInputs = with pkgs; [
        chafa
        ffmpeg
    ];

    src = pkgs.fetchFromGitHub {
        owner = "ozemin";
        repo = "lazycut";
        rev = "v${version}";
        hash = "sha256-SWcxk8GiXX81UZwv//1lukvXLtgMiJ7u4Rx1z6CKQoY=";
    };

    vendorHash = "sha256-KfVNSESu06xiFYb+r2Yv4rgDc/NZ1tuGC0IWUdQrywo=";

}

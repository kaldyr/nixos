{ lib, pkgs, }:

pkgs.rustPlatform.buildRustPackage rec {

    pname = "lowfi";
    version = "1.5.6";

    src = pkgs.fetchFromGitHub {
        owner = "talwat";
        repo = "lowfi";
        rev = version;
        hash = "sha256-lR22UN9LiuJknq2KTNOXcybXwi2KvLRe0KHocFWL0GM=";
    };

    cargoHash = "sha256-lH/8n0NcGl+EagE3o9K/+wB47h4a4CwBWsZWFcoMxG0=";

    cargoBuildFlags = [ "--features mpris" ];

    nativeBuildInputs = [ pkgs.pkg-config ];

    buildInputs = with pkgs; [
        alsa-lib
        openssl
    ];

    meta = {
        changelog = "https://github.com/talwat/lowfi/releases/tag/${src.rev}";
        description = "lowfi is a tiny rust app that serves a single purpose: play lofi. It'll do this as simply as it can: no albums, no ads, just lofi.";
        homepage = "https://github.com/talwat/lowfi";
        license = lib.licenses.mit;
        mainProgram = "lowfi";
        maintainers = with lib.maintainers; [ kaldyr ];
        platforms = lib.platforms.linux;
    };

}

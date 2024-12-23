{ pkgs, ... }: pkgs.stdenv.mkDerivation {

    pname = "wayland-push-to-talk-fix";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
        owner = "Rush";
        repo = "wayland-push-to-talk-fix";
        rev = "490f43054453871fe18e7d7e9041cfbd0f1d9b7d";
        hash = "sha256-ZRSgrQHnNdEF2PyaflmI5sUoKCxtZ0mQY/bb/9PH64c=";
    };

    nativeBuildInputs = with pkgs; [ pkg-config ];

    buildInputs = with pkgs; [
        libevdev
        xdotool
        xorg.libX11
        xorg.xorgproto
    ];

    installPhase = ''
        mkdir -p $out/bin
        cp push-to-talk $out/bin/wayland-push-to-talk-fix
    '';

}

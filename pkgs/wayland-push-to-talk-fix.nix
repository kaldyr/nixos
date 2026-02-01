{ pkgs, ... }: pkgs.stdenv.mkDerivation {

    pname = "wayland-push-to-talk-fix";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
        owner = "Rush";
        repo = "wayland-push-to-talk-fix";
        rev = "fecb045c90916ae0cd0414948e0af561dd9ea579";
        hash = "sha256-nvoeeOVBVm0GhTpsf8LkYUBXeRWDqdWuEO9FV8La13g=";
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

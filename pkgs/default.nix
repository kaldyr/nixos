pkgs: {

    maple-mono-7 = pkgs.callPackage ./maple-mono.nix { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };

}

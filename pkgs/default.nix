pkgs: {

    maple-mono-7 = pkgs.callPackage ./maple-mono.nix { };
    recursive-mono-custom = pkgs.callPackage ./recursive-mono.nix { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };

}

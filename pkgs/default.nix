pkgs: {
    keepmenu = pkgs.callPackage ./keepmenu.nix { };
    maple-mono-custom = pkgs.callPackage ./maple-mono.nix { };
    openstarbound = pkgs.callPackage ./openstarbound { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };
}

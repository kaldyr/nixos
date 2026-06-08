pkgs: {

    keepmenu = pkgs.callPackage ./keepmenu.nix { };
    maple-mono-custom = pkgs.callPackage ./maple-mono.nix { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };

}

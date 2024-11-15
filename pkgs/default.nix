pkgs: {

    lazysql = pkgs.callPackage ./lazysql.nix { };
    lowfi = pkgs.callPackage ./lowfi.nix { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };

}

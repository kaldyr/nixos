pkgs: {

    # lazysql = pkgs.callPackage ./lazysql.nix { };
    lowfi = pkgs.callPackage ./lowfi.nix { };
    maple-mono-7 = pkgs.callPackage ./maple-mono.nix { };
    recursive-mono-custom = pkgs.callPackage ./recursive-mono.nix { };
    wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };

}

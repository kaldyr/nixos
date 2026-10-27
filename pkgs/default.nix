pkgs: {
  maple-mono-custom = pkgs.callPackage ./maple-mono { };
  wayland-push-to-talk-fix = pkgs.callPackage ./wayland-push-to-talk-fix.nix { };
}

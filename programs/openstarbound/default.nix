{
  pkgs,
  ...
}:
let
  openstarboundClient = pkgs.writeShellApplication {
    name = "openstarbound";

    text = ''
      assets="$HOME/.local/share/openstarbound"
      storage="$HOME/.local/state/openstarbound/storage"
      logs="$HOME/.local/state/openstarbound/logs"
      config="$assets/sbinit.config"

      mkdir -p "$assets/assets" \
               "$assets/mods" \
               "$storage" \
               "$logs"

      cat > "$config" <<EOF
      {
          "assetDirectories" : [
              "$assets/assets/",
              "$assets/mods/",
              "${pkgs.openstarbound}/assets/"
          ],
          "storageDirectory" : "$storage/",
          "logDirectory" : "$logs/"
      }
      EOF

      exec ${pkgs.openstarbound}/bin/starbound -bootconfig "$config" "$@"
    '';
  };
in
{
  environment.systemPackages = [ openstarboundClient ];
}

{
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 21025 ];

  systemd.services."starbound" = {
    description = "OpenStarbound server";

    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "starbound";
      Group = "starbound";
      DynamicUser = lib.mkForce false;
      ProtectHome = true;
    };

    script = /* bash */ ''
      assets="/state/openstarbound";
      storage="/state/openstarbound/storage";
      logs="/state/openstarbound/logs";
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

      exec ${pkgs.openstarbound}/bin/starbound_server -bootconfig "$config"
    '';
  };

  users = {
    groups."starbound" = { };

    extraUsers."starbound" = {
      group = "starbound";
      isSystemUser = true;
    };
  };
}

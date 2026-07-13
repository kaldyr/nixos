{ lib, pkgs, ... }: {

    imports = [ ../programs/openstarbound.nix ];

    networking.firewall.allowedTCPPorts = [ 21025 ];

    systemd.services."starbound" = {
        description = "OpenStarbound server";

        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
            User = "starbound";
            Group = "starbound";
            DynamicUser = lib.mkForce false;
        };

        script = /* bash */ ''
            ${pkgs.openstarbound}/bin/starbound_server -bootconfig /var/lib/openstarbound/sbinit.config
        '';
    };
}

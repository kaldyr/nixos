{ lib, ... }: {

    environment.persistence."/state/system".directories = [ {
        directory = "/var/lib/technitium-dns-server";
        user = "technitium";
        group = "technitium";
        mode = "0750";
    } ];

    services.technitium-dns-server = {
        enable = true;
        openFirewall = true;
    };

    systemd.services.technitium-dns-server = {
        serviceConfig = {
            User = "technitium";
            Group = "technitium";
            DynamicUser = lib.mkForce false;
        };
    };

    users.extraUsers."technitium" = {
        extraGroups = [ "webservice" ];
        group = "technitium";
        home = "/var/lib/technitium";
        isSystemUser = true;
    };

}

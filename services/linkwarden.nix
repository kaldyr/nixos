{

    environment.persistence."/state/system".directories = [ {
        directory = "/var/lib/linkwarden";
        user = "linkwarden";
        group = "linkwarden";
        mode = "0750";
    } ];

    services.linkwarden = {
        enable = true;
        openFirewall = true;
    };

    users.groups.linkwarden = { };
    users.users.linkwarden = {
        isSystemUser = true;
        group = "linkwarden";
    };

}

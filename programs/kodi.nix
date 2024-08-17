{ pkgs, ... }: {

    networking.firewall.allowedTCPPorts = [ 8080 9090 ];
    networking.firewall.allowedUDPPorts = [ 8080 9090 ];

    services = {

        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = "kodi";

        xserver = {

            enable = true;

            desktopManager.kodi = {

                enable = true;

                package = (pkgs.kodi-wayland.withPackages (kodiPackages: with kodiPackages; [
                    inputstream-adaptive
                    sendtokodi
                    youtube
                ]));

            };

        };

    };

    users.extraUsers.kodi.isNormalUser = true;

}

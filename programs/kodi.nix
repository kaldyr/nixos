{ pkgs, ... }: {

    networking.firewall.allowedTCPPorts = [ 8080 9090 ];
    networking.firewall.allowedUDPPorts = [ 8080 9090 ];

    services = {

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

            displayManager.autoLogin.enable = true;
            displayManager.autoLogin.user = "kodi";

        };

    };

    users.extraUsers.kodi.isNormalUser = true;

}

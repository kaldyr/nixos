{ pkgs, ... }: {

    environment.persistence."/state".users.kodi.directories = [
        { directory = ".cache"; mode = "0700"; }
        ".compose-cache"
        ".kodi"
    ];

    networking.firewall.allowedTCPPorts = [ 8080 9090 ];
    networking.firewall.allowedUDPPorts = [ 8080 9090 ];

    services = {

        displayManager.autoLogin.enable = true;
        displayManager.autoLogin.user = "kodi";
        pipewire.systemWide = true;

        xserver = {

            enable = true;

            desktopManager.kodi = {

                enable = true;

                package = (pkgs.kodi-wayland.withPackages (kodiPackages: with kodiPackages; [
                    inputstream-adaptive
                    youtube
                ]));

            };

        };

    };

    users.extraUsers.kodi.isNormalUser = true;
    users.extraUsers.kodi.extraGroups = [ "audio" "pipewire" "video" ];

}

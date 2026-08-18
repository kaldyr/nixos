{ pkgs, ... }: {
  environment.persistence."/state".directories = [ "/var/lib/kodi/.kodi" ];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
  ];
  networking.firewall.allowedUDPPorts = [
    8080
    9090
  ];

  services = {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "kodi";
    pipewire.systemWide = true;

    xserver = {
      enable = true;

      desktopManager.kodi = {
        enable = true;

        package = (
          pkgs.kodi-wayland.withPackages (
            kodiPackages: with kodiPackages; [
              inputstream-adaptive
              youtube
            ]
          )
        );
      };
    };
  };

  users.extraUsers.kodi = {
    isNormalUser = true;

    home = "/var/lib/kodi";

    extraGroups = [
      "audio"
      "pipewire"
      "video"
    ];
  };
}

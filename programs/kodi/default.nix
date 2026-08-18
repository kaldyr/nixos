{ pkgs, ... }: {
  environment.persistence."/state".directories = [{
    directory = "/var/lib/kodi/.kodi";
    user = "kodi";
    group = "users";
    mode = "0750";
  }];

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

  sops.secrets.kodi-password.neededForUsers = true;

  users.users.kodi = {
    extraGroups = [
      "audio"
      "pipewire"
      "video"
    ];

    home = "/var/lib/kodi";
    isNormalUser = true;
    uid = 1001;
  };
}

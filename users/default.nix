{
  inputs,
  sysConfig,
  pkgs,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs sysConfig; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${sysConfig.user} = {
      home = {
        homeDirectory = "/home/${sysConfig.user}";
        stateVersion = sysConfig.stateVersion;
        username = sysConfig.user;
      };

      programs.git = {
        enable = true;
        settings.safe.directory = "/nix/config";
      };

      programs.home-manager.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      xdg.enable = true;
    };
  };

  users = {
    mutableUsers = false;

    users.${sysConfig.user} = {
      extraGroups = [
        "input"
        "networkmanager"
        "nixconfig"
        "video"
        "wheel"
      ];

      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEI16mw0+rV583qqsxv0zjEUfGgcwXczuOYFjWrDYmg matt@magrathea"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
      ];

      shell = pkgs.fish;
      uid = 1000;
    };
  };
}

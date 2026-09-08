{
  lib,
  pkgs,
  sysConfig,
  ...
}:
let
  common = {
    control = {
      comma = "macro([b)";
      "." = "macro(]b)";
    };

    layerCaps = {
      # For fast vim arrow movements without exiting insert mode
      h = "left";
      j = "down";
      k = "up";
      l = "right";
      # Extra keybinds for games from the numpad
      "1" = "kp1";
      "2" = "kp2";
      "3" = "kp3";
      "4" = "kp4";
      "5" = "kp5";
      "z" = "kp6";
      "q" = "kp7";
      "e" = "kp8";
      "r" = "kp9";
      "t" = "kp0";
      "f" = "kpminus";
      "g" = "kpplus";
      "v" = "kpdot";
    };

    main = {
      capslock = "overload(layerCaps, esc)";
      leftcontrol = "layer(control)";
    };
  };
in
{

  home-manager.users.${sysConfig.user} = {
    home.packages = with pkgs; [ keyd ];

    systemd.user.services.keyd-application-mapper = {
      Install.WantedBy = [ "graphical-session.target" ];

      Unit = {
        Description = "Keyd Application Mapper";
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    xdg.configFile = lib.mkIf (sysConfig.user == "nic") {
      "keyd/app.conf".text = ''
        [kitty]
        capslock = esc

        [gw2-64-exe]
        capslock = leftalt
      '';
    };
  };

  services.keyd = {
    enable = true;

    keyboards = {
      default.settings = common;

      air60 = {
        ids = [ "19f5:3255:0d7157bb" ];

        settings = lib.recursiveUpdate common {
          main = {
            esc = "`";
            rightalt = "layer(layerRightAlt)";
            rightshift = "print";
          };

          layerRightAlt = {
            "1" = "brightnessdown";
            "2" = "brightnessup";
            "3" = "M-a";
            "4" = "M-r";
            "5" = "micmute";
            "6" = "M-p";
            "7" = "previoussong";
            "8" = "playpause";
            "9" = "nextsong";
            "0" = "mute";
            "minus" = "volumedown";
            "equal" = "volumeup";
          };
        };
      };

      magma = {
        ids = [ "1e7d:3124:37a054cc" ];
        settings.main = { };
      };
    };
  };

  systemd.services.keyd.serviceConfig = {
    Group = "keyd";

    NoNewPrivileges = lib.mkForce false;
    RestrictSUIDSGID = lib.mkForce false;

    CapabilityBoundingSet = lib.mkForce [
      "CAP_SYS_NICE"
      "CAP_IPC_LOCK"
      "CAP_SETGID"
    ];

    SystemCallFilter = lib.mkForce [
      "nice"
      "@system-service"
    ];
  };

  users.users.${sysConfig.user}.extraGroups = [ "keyd" ];
  users.groups.keyd.gid = 985;
}

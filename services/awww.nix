{ lib, pkgs, sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = {
        services.awww.enable = true;
        services.awww.extraArgs = [ "--format" "xrgb" ];

        systemd.user.services.wallpaper-change = {
            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                Description = "Set the wallpaper";
                PartOf = [ "graphical-session.target" ];
                After = [ "awww.service" ];
                Requires = [ "awww.service" ];
            };

            Service = {
                ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
                ExecStart = toString (
                    pkgs.writeShellScript "wallpaper-change" ''
                        ${pkgs.awww}/bin/awww img "$(${pkgs.findutils}/bin/find $HOME/Pictures/Wallpapers -type f | ${pkgs.coreutils}/bin/shuf -n 1)"
                    '' );
                Type = "oneshot";
            };
        };

        systemd.user.timers.wallpaper-change = {
            Unit.Description = "Set the wallpaper";

            Install.WantedBy = [ "timers.target" ];
            Timer = {
                OnCalendar = "*:0/1";
                Unit = "wallpaper-change.service";
                Persistent = true;
            };
        };
    };
}

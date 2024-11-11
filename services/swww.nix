{ lib, pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ swww ];

        systemd.user.services.swww = {
            Install.WantedBy = [ "graphical-session.target" ];
            Unit.Description = "Wayland wallpaper daemon";
            Unit.PartOf = [ "graphical-session.target" ];
            Service.ExecStart = "${lib.getExe' pkgs.swww "swww-daemon"} --format xrgb";
            Service.Restart = "on-failure";
        };

        systemd.user.services.wallpaper-change = {

            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                Description = "Set the wallpaper";
                PartOf = [ "graphical-session.target" ];
                After = [ "swww.service" ];
                Requires = [ "swww.service" ];
            };

            Service = {
                ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
                ExecStart = toString (
                    pkgs.writeShellScript "wallpaper-change" ''
                        image="$(${pkgs.findutils}/bin/find $HOME/Pictures/Wallpapers -type f | ${pkgs.coreutils}/bin/shuf -n 1)"
                        ${pkgs.swww}/bin/swww img $image
                    '' );
                Type = "oneshot";
            };

        };

        systemd.user.timers.wallpaper-change = {

            Unit.Description = "Set the wallpaper";

            Install.WantedBy = [ "timers.target" ];

            Timer = {
                OnCalendar = "*:0/2";
                Unit = "wallpaper-change.service";
                Persistent = true;
            };

        };

    };

}

{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ swww ];

        systemd.user.services.wallpaper-change = {

            Unit.Description = "Set the wallpaper";

            Service.ExecStart = toString (
                pkgs.writeShellScript "wallpaper-change" ''
                    image="$(${pkgs.findutils}/bin/find $HOME/Pictures/Wallpapers -type f | ${pkgs.coreutils}/bin/shuf -n 1)"
                    ${pkgs.swww}/bin/swww img $image
                '' );

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

{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ dunst ];

        services.dunst = {

            enable = true;

            iconTheme = {
                name = "Papirus";
                package = pkgs.catppuccin-papirus-folders;
                size = "16x16";
            };

            settings = {

                global = {
                    corner_radius = 10;
                    font = "Inter 10";
                    frame_color = "#8CAAEE";
                    mouse_left_click = "close_current";
                    mouse_middle_click = "do_action";
                    mouse_right_click = "close_all";
                    separator_color = "frame";
                };
                
                urgency_critical = {
                    background = "#303446";
                    foreground = "#C6D0F5";
                    frame_color = "#EF9F76";
                    timeout = 10;
                };

                urgency_low = {
                    background = "#303446";
                    foreground = "#C6D0F5";
                    timeout = 4;
                };

                urgency_normal = {
                    background = "#303446";
                    foreground = "#C6D0F5";
                    timeout = 4;
                };

            };

        };

    };

}

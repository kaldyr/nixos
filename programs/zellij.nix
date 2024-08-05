{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.programs.zellij = {

        enable = true;

        enableFishIntegration = false;

        settings = {

            copy_clipboard = "primary";
            copy_command = "wl-copy";
            copy_on_select = true;
            default_layout = "compact";

            keybinds = {
                unbind = [
                    "Ctrl b"
                    "Ctrl c"
                    "Ctrl f"
                    "Ctrl g"
                    "Ctrl h"
                    "Ctrl n"
                    "Ctrl o"
                    "Ctrl p"
                    "Ctrl q"
                    "Ctrl s"
                    "Ctrl t"
                ];

                locked = { "bind \"Alt g\"" = { SwitchToMode = "normal"; }; };
                move = { "bind \"Alt m\"" = { SwitchToMode = "normal"; }; };

                normal = {
                    "bind \"Alt g\"" = { SwitchToMode = "locked"; };
                    "bind \"Alt m\"" = { SwitchToMode = "move"; };
                    "bind \"Alt o\"" = { SwitchToMode = "session"; };
                    "bind \"Alt p\"" = { SwitchToMode = "pane"; };
                    "bind \"Alt n\"" = { SwitchToMode = "resize"; };
                    "bind \"Alt s\"" = { SwitchToMode = "scroll"; };
                    "bind \"Alt t\"" = { SwitchToMode = "tab"; };
                    "bind \"Alt q\"" = { SwitchToMode = "scroll"; };
                    "bind \"Alt 1\"" = { GoToTab = 1; };
                    "bind \"Alt 2\"" = { GoToTab = 2; };
                    "bind \"Alt 3\"" = { GoToTab = 3; };
                    "bind \"Alt 4\"" = { GoToTab = 4; };
                    "bind \"Alt 5\"" = { GoToTab = 5; };
                    "bind \"Alt 6\"" = { GoToTab = 6; };
                    "bind \"Alt 7\"" = { GoToTab = 7; };
                    "bind \"Alt 8\"" = { GoToTab = 8; };
                    "bind \"Alt 9\"" = { GoToTab = 9; };
                    "bind \"Alt 0\"" = { GoToTab = 10; };
                };

                pane = { "bind \"Alt p\"" = { SwitchToMode = "normal"; }; };
                resize = { "bind \"Alt r\"" = { SwitchToMode = "normal"; }; };
                scroll = { "bind \"Alt s\"" = { SwitchToMode = "normal"; }; };
                session = { "bind \"Alt o\"" = { SwitchToMode = "normal"; }; };
                tab = { "bind \"Alt t\"" = { SwitchToMode = "normal"; }; };

            };

            pane_frames = false;
            theme = "catppuccin-frappe";

            ui.pane_frames = {
                hide_session_name = true;
                rounded_corners = true;
            };

        };

    };

}

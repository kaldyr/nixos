{

    programs.waybar = {

        enable = true;

        settings = [{
            layer = "top";
            position = "top";
            exclusive = false;
            passthrough = false;
            gtk-layer-shell = true;
            height = 24;
            modules-center = [
                "hyprland/workspaces"
                "temperature"
                "battery"
                "pulseaudio#output"
                "pulseaudio#input"
                "clock"
                "tray"
            ];
            "hyprland/window" = {
                format = "{}";
            };

            "hyprland/workspaces" = {
                format = "{icon}";
                all-outputs = true;
                sort-by-number = true;
                on-click = "activate";
                on-scroll-up = "hyprctl dispatch workspace e-1";
                on-scroll-down = "hyprctl dispatch workspace e+1";
                format-icons = {
                    urgent = "";
                    active = "";
                    default = "";
                };
            };

            temperature = {
                hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
                format = " ";
                critical-threshold = 75;
            };

            battery = {
                format = "<span font='Font Awesome 5 Free 11'>{icon}</span>  ";
                tooltip-format = "{capacity}% - {time}";
                format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
                format-time = "{H}h {M}m";
                format-charging = "<span font='Font Awesome 5 Free'></span>  <span font='Font Awesome 5 Free 11'>{icon}</span>  ";
                interval = 30;
                states = {
                    warning = 25;
                    critical = 10;
                };
                tooltip = true;
                on-click = "2";
            };

            "pulseaudio\#output" = {
                format = "{volume}% {icon} ";
                format-muted = " ";
                on-click = "pamixer -t";
                on-click-right = "pavucontrol --tab=3";
                on-scroll-up = "pamixer -i 1";
                on-scroll-down = "pamixer -d 1";
                format-icons = {
                    headphone = "";
                    hands-free = "";
                    headset = "";
                    phone = "";
                    portable = "";
                    car = "";
                    default = ["" "" ""];
                };
            };

            "pulseaudio#input" = {
                format = "{format_source}";
                format-source = " {volume}%";
                format-source-muted = " ";
                tooltip = false;
                on-click = "pamixer --default-source -t";
                on-click-right = "pavucontrol --tab=4";
                on-scroll-up = "pamixer --default-source -i 1";
                on-scroll-down = "pamixer --default-source -d 1";
            };

            clock = {
                format = "   {:%H:%M    -    %a, %b %e}   󰸗";
                tooltip-format = "<tt>{calendar}</tt>";
            };

            tray = {
                icon-size = 14;
                spacing = 8;
            };

        }];

        style = ''
            @define-color base   #303446;
            @define-color mantle #292c3c;
            @define-color crust  #232634;

            @define-color text     #c6d0f5;
            @define-color subtext0 #a5adce;
            @define-color subtext1 #b5bfe2;

            @define-color surface0 #414559;
            @define-color surface1 #51576d;
            @define-color surface2 #626880;

            @define-color overlay0 #737994;
            @define-color overlay1 #838ba7;
            @define-color overlay2 #949cbb;

            @define-color blue      #8caaee;
            @define-color lavender  #babbf1;
            @define-color sapphire  #85c1dc;
            @define-color sky       #99d1db;
            @define-color teal      #81c8be;
            @define-color green     #a6d189;
            @define-color yellow    #e5c890;
            @define-color peach     #ef9f76;
            @define-color maroon    #ea999c;
            @define-color red       #e78284;
            @define-color mauve     #ca9ee6;
            @define-color pink      #f4b8e4;
            @define-color flamingo  #eebebe;
            @define-color rosewater #f2d5cf;

            * {
                font-size: 10px;
                font-family: "Ubuntu Nerd Font", "Font Awesome 6 Free";
            }

            window#waybar {
                background: rgba(0,0,0,0);
            }

            tooltip {
                background: @mantle;
                color: @teal;
            }

            #workspaces {
                background: @mantle;
                padding: 0 8px;
                border-radius: 0 0 0 10px;
            }

            #workspaces button {
                background: @crust;
                color: @teal;
                margin: 0 2px;
                padding: 0 2px;
                border-radius: 2px;
                min-width: 18px;
            }
            #workspaces button.active {
                background: @teal;
                color: @crust;
                font-weight: bold;
            }

            #workspaces button.urgent {
                background: @red;
                color: @crust
            }

            #workspaces button:hover {
                background: @peach;
                color: @crust;
                box-shadow: inherit;
                text-shadow: inherit;
            }

            #temperature {
                padding: 0 6px 0 0;
                background: @mantle;
                color: @sapphire;
            }

            #temperature.critical {
                color: @red;
            }

            #battery {
                padding: 0 6px 0 0;
                background: @mantle;
                color: @sapphire;
            }

            #battery.critical {
                color: @red;
            }

            #pulseaudio {
                padding: 0 6px;
                background: @mantle;
            }

            #pulseaudio.output {
                color: @mauve;
            }

            #pulseaudio.input {
                color: @flamingo;
            }

            #pulseaudio.bluetooth {
                color: @blue;
            }

            #pulseaudio.output.muted {
                color: @maroon;
            }

            #pulseaudio.input.source-muted {
                color: @maroon;
            }

            #clock {
                padding: 0 6px 0 0;
                font-weight: bold;
                background: @mantle;
                color: @blue;
            }

            #tray {
                background: @crust;
                padding: 0 8px;
                border-radius: 0 0 10px 0;
            }
        '';

    };

}

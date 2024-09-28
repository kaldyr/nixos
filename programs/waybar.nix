{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.waybar.enable = true;

        xdg.configFile."waybar/config".text = let

            hwmon-path = (
                if sysConfig.hostname == "mjolnir" then
                    "/sys/devices/pci0000:00/0000:00:08.1/0000:c4:00.0/hwmon"
                else if sysConfig.hostname == "gram" then 
                    "/sys/devices/platform/coretemp.0/hwmon"
                else
                    ""
                );

        in /* json */ ''
            [
                {
                    "battery": {
                        "format": "<span font='Font Awesome 5 Free 11'>{icon}</span>  ",
                        "format-charging": "<span font='Font Awesome 5 Free'></span>  <span font='Font Awesome 5 Free 11'>{icon}</span>  ",
                        "format-icons": [ "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" ],
                        "format-time": "{H}h {M}m",
                        "interval": 30,
                        "on-click": "2",
                        "states": {
                            "critical": 10,
                            "warning": 25,
                        },
                        "tooltip": true,
                        "tooltip-format": "{capacity}% - {time}",
                    },
                    "clock": {
                        "format": "  {:%H:%M  -  %a, %b %e}  󰸗",
                        "tooltip-format": "<tt>{calendar}</tt>",
                    },
                    "exclusive": false,
                    "gtk-layer-shell": true,
                    "height": 24,
                    "hyprland/window": {
                        "format": "{}",
                    },
                    "hyprland/workspaces": {
                        "all-outputs": true,
                        "format": "{icon}",
                        "format-icons": {
                            "active": " ",
                            "default": " ",
                            "urgent": " ",
                        },
                        "on-click": "activate",
                        "on-scroll-down": "hyprctl dispatch workspace e+1",
                        "on-scroll-up": "hyprctl dispatch workspace e-1",
                        "sort-by-number": true,
                    },
                    "layer": "top",
                    "mode": "dock",
                    "modules-center": [
                        "clock",
                    ],
                    "modules-left": [
                        "hyprland/workspaces",
                    ],
                    "modules-right": [
                        "temperature",
                        "pulseaudio#output",
                        "pulseaudio#input",
                        "battery",
                        "tray",
                    ],
                    "passthrough": false,
                    "position": "top",
                    "pulseaudio#input": {
                        "format": "{format_source}",
                        "format-source": " {volume}%",
                        "format-source-muted": " ",
                        "on-click": "pamixer --default-source -t",
                        "on-click-right": "pavucontrol --tab=4",
                        "on-scroll-down": "pamixer --default-source -d 1",
                        "on-scroll-up": "pamixer --default-source -i 1",
                        "tooltip": false,
                    },
                    "pulseaudio#output": {
                        "format": "{volume}% {icon} ",
                        "format-icons": {
                            "car": " ",
                            "default": [ "", "", "" ],
                            "hands-free": " ",
                            "headphone": " ",
                            "headset": " ",
                            "phone": " ",
                            "portable": " ",
                        },
                        "format-muted": " ",
                        "on-click": "pamixer -t",
                        "on-click-right": "pavucontrol --tab=3",
                        "on-scroll-down": "pamixer -d 1",
                        "on-scroll-up": "pamixer -i 1",
                    },
                    "temperature": {
                        "critical-threshold": 75,
                        "format": "",
                        "hwmon-path-abs": "${hwmon-path}",
                        "input-filename": "temp1_input",
                    },
                    "tray": {
                        "icon-size": 12,
                        "spacing": 12
                    }
                }
            ]
        '';

        xdg.configFile."waybar/style.css".text = /* css */ ''
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
                font-family: "Inter", "Font Awesome 6 Free";
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
                padding: 0 10px;
                border-radius: 0 0 10px 0;
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
                background: @mantle;
                color: @sapphire;
                border-radius: 0 0 0 10px;
                padding: 0 10px 0 10px;
            }

            #temperature.critical {
                color: @red;
            }

            #battery {
                background: @mantle;
                color: @sapphire;
                padding: 0 0 0 5px;
            }

            #battery.critical {
                color: @red;
            }

            #pulseaudio {
                background: @mantle;
                padding: 0 5px;
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
                font-weight: bold;
                background: @mantle;
                color: @blue;
                padding: 0 12px 0 10px;
                border-radius: 0 0 12px 12px;
            }

            #tray {
                background: @crust;
                padding: 0 8px;
            }
        '';

    };

}

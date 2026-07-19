{ lib, pkgs, ... }:
let
    common = {
        control = {
            comma = "macro([b)";
            "." = "macro(]b)";
        };

        layerCaps = {
            # For WASD games, turn instead of strafe when layer active
            a = "left";
            d = "right";
            w = "up";
            s = "down";
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
in {

    environment.systemPackages = with pkgs; [ keyd ];

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

                    layerCaps = {
                        "delete" = "insert";
                    };
                };
            };
        };
	};
}

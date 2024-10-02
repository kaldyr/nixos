{

    services.keyd = {

        enable = true;

        keyboards.default.settings = {

            layerCaps = {

                # For WASD games, turn instead of strafe when layer active
                a = "left";
                d = "right";
                w = "up";
                s = "down";

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

                # For fast vim arrow movements without exiting insert mode
                h = "left";
                j = "down";
                k = "up";
                l = "right";

            };

            layerRightAlt = {

                "1" = "f1";
                "2" = "f2";
                "3" = "f3";
                "4" = "f4";
                "5" = "f5";
                "6" = "f6";
                "7" = "f7";
                "8" = "f8";
                "9" = "f9";
                "0" = "f10";
                "minus" = "f11";
                "equal" = "f12";

            };

            main = {
                capslock = "overload(layerCaps, esc)";
                esc = "overload(layerCaps, esc)";
                rightalt = "overload(layerRightAlt, rightalt)"; 
            };

        };

    };

}

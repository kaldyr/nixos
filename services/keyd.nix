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

				# Extra functionality for 60% keyboard
				"delete" = "insert";

			};

			layerRightAlt = {
				# Media Keys (Mac order to match Nuphy Air60)
				"1" = "brightnessdown";
				"2" = "brightnessup";
				"3" = "M-f";
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

			main = {
				capslock = "overload(layerCaps, esc)";
				rightalt = "overload(layerRightAlt, rightalt)";
				leftcontrol = "layer(control)";
			};

			control = {
				comma = "macro([b)";
				"." = "macro(]b)";
			};

		};
	};


}

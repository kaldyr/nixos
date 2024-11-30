{ lib, pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [ gammastep ];

		services.gammastep = {

			enable = true;

			latitude = 47.2;
			longitude = -122.3;
			provider = "manual";

			settings.general = {
				temp-day = lib.mkForce 6500;
				temp-night = lib.mkForce 3600;
				brightness-day = lib.mkForce 1.0;
				brightness-night = lib.mkForce 0.85;
			};

			tray = true;

		};

		xdg.desktopEntries.gammastep-indicator = { name = "Gammastep Indicator"; noDisplay = true; };

	};

}

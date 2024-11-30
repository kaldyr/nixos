{ pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [ hypridle ];

		services.hypridle.enable = (
			# Mjolnir hyprlock crash when left for minutes
			if sysConfig.hostname == "mjolnir" then false
			else true
		);

		xdg.configFile."hypr/hypridle.conf".text = /* hyprlang */ ''
			general {
				lock_cmd = pidof hyprlock || hyprlock
				before_sleep_cmd = loginctl lock-session
				after_sleep_cmd = hyprctl dispatch dpms on
			}

			listener {
				timeout = 600
				on-timeout = loginctl lock-session
			}

			listener {
				timeout = 630
				on-timeout = hyprctl dispatch dpms off
				on-resume = hyprctl dispatch dpms on
			}
		'';

	};

}

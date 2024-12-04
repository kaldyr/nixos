{ pkgs, sysConfig, ... }: {

	# environment.persistence."nix".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [
			keepassxc
			keepmenu
		];

	};

}

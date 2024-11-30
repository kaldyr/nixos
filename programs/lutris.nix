{ pkgs, sysConfig, ... }: {

	environment.persistence."/nix".users.${sysConfig.user}.directories = [
		".cache/lutris"
		".local/share/lutris"
		".wine"
	];

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [
			lutris
			gamemode
			wine
		];

	};

}

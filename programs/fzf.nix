{ sysConfig, ... }: {

	home-manager.users.${sysConfig.user}.programs.fzf = {

		enable = true;

		# enableFishIntegration = true;

	};

}

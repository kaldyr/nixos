{ pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = { config, ... }: {
		home.packages = with pkgs; [ swappy ];
		xdg.configFile."swappy/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/swappy/config";
	};

}

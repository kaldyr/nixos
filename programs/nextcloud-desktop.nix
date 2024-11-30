{ lib, pkgs, sysConfig, ... }: {

	environment.persistence."/state".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];

	home-manager.users.${sysConfig.user} = let

		ncInitialConfig = /* ini */ ''
			[General]
			launchOnSystemStartup=true

			[Accounts]
			0\authType=webflow
			0\dav_user=${sysConfig.user}
			0\url=https://magrathea.brill-godzilla.ts.net
			0\version=1
			0\webflow_user=${sysConfig.user}
			0\Folders\1\ignoreHiddenFiles=false
			0\Folders\1\localPath=/home/${sysConfig.user}/Books
			0\Folders\1\paused=false
			0\Folders\1\targetPath=/Books
			0\Folders\1\version=2
			0\Folders\1\virtualFilesMode=off
			0\Folders\2\ignoreHiddenFiles=false
			0\Folders\2\localPath=/home/${sysConfig.user}/Documents
			0\Folders\2\paused=false
			0\Folders\2\targetPath=/Documents
			0\Folders\2\version=2
			0\Folders\2\virtualFilesMode=off
			0\Folders\3\ignoreHiddenFiles=false
			0\Folders\3\localPath=/home/${sysConfig.user}/Music
			0\Folders\3\paused=false
			0\Folders\3\targetPath=/Music
			0\Folders\3\version=2
			0\Folders\3\virtualFilesMode=off
			0\Folders\4\ignoreHiddenFiles=false
			0\Folders\4\localPath=/home/${sysConfig.user}/Notes
			0\Folders\4\paused=false
			0\Folders\4\targetPath=/Notes
			0\Folders\4\version=2
			0\Folders\4\virtualFilesMode=off
			0\Folders\5\ignoreHiddenFiles=false
			0\Folders\5\localPath=/home/${sysConfig.user}/Pictures
			0\Folders\5\paused=false
			0\Folders\5\targetPath=/Pictures
			0\Folders\5\version=2
			0\Folders\5\virtualFilesMode=off
			0\Folders\6\ignoreHiddenFiles=false
			0\Folders\6\localPath=/home/${sysConfig.user}/Videos
			0\Folders\6\paused=false
			0\Folders\6\targetPath=/Videos
			0\Folders\6\version=2
			0\Folders\6\virtualFilesMode=off
		'';

	in  {

		home.activation.initConfig = lib.mkAfter /* bash */ ''
			if [ ! -d "/home/${sysConfig.user}/.config/Nextcloud" ]; then
				mkdir -p "/home/${sysConfig.user}/.config/Nextcloud"
			fi

			if [ ! -f "/home/${sysConfig.user}/.config/Nextcloud/nextcloud.cfg" ]; then
				echo "${ncInitialConfig}" > /home/${sysConfig.user}/.config/Nextcloud/nextcloud.cfg
			fi
		'';

		home.packages = with pkgs; [ nextcloud-client ];
		
		services.nextcloud-client = {
			enable = true;
			package = pkgs.nextcloud-client;
			startInBackground = true;
		};
		
	};

}

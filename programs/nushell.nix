{ sysConfig, ... }: {

	environment.persistence."/nix".users.${sysConfig.user}.files = [
		".config/nushell/history.sqlite3"
		".config/nushell/history.sqlite3-shm"
		".config/nushell/history.sqlite3-wal"
	];

	home-manager.users.${sysConfig.user} = {

		programs.nushell = {

			enable = true;

			extraConfig = /* nu */ ''
				$env.config = {
					completions: {
						algorithm: fuzzy
					}

					edit_mode: vi

					history: {
						sync_on_enter: true
						file_format: "sqlite"
					}

					show_banner: false
				}
			'';

		};

	};

}

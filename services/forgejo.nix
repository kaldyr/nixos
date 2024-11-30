{ pkgs, ... }: {

	imports = [ ./postgresql.nix ];

	environment.persistence."/state/system".directories = [ {
		directory = "/var/lib/forgejo";
		user = "forgejo";
		group = "forgejo";
		mode = "0700";
	} ];

	networking.firewall.allowedTCPPorts = [ 2222 9001 ];
	networking.firewall.allowedUDPPorts = [ 2222 9001 ];

	services = {

		forgejo = {

			enable = true;
			package = pkgs.forgejo;

			user = "forgejo";
			group = "forgejo";
			stateDir = "/var/lib/forgejo";

			database = {
				createDatabase = true;
				name = "forgejo";
				type = "postgres";
				user = "forgejo";
			};

			dump.enable = false;
			lfs.enable = true;

			settings = {

				DEFAULT.APP_NAME = "Project Forge";

				log.LEVEL = "Warn";

				repository.ENABLE_PUSH_CREATE_USER = true;
				repository.DEFAULT_BRANCH = "main";

				server = {
					CERT_FILE = "/var/lib/certs/magrathea.brill-godzilla.ts.net.crt";
					KEY_FILE = "/var/lib/certs/magrathea.brill-godzilla.ts.net.key";
					DOMAIN = "magrathea.brill-godzilla.ts.net";
					HTTP_ADDR = "0.0.0.0";
					HTTP_PORT = 9001;
					PROTOCOL = "https";
					ROOT_URL = "https://magrathea.brill-godzilla.ts.net:9001";
					BUILTIN_SSH_SERVER_USER = "git";
					SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
					SSH_LISTEN_HOST = "0.0.0.0";
					SSH_LISTEN_PORT = 2222;
					SSH_PORT = 2222;
					START_SSH_SERVER = true;
				};

				service.DISABLE_REGISTRATION = true; # Comment out for initial install
				session.COOKIE_SECURE = true;

			};

			useWizard = false;

		};

		postgresql.ensureDatabases = [ "forgejo" ];
		postgresql.ensureUsers = [ { name = "forgejo"; ensureDBOwnership = true; } ];
		postgresqlBackup.databases = [ "forgejo" ];

	};

	users.extraUsers."forgejo" = {
		extraGroups = [ "webservice" ];
		group = "forgejo";
		home = "/var/lib/forgejo";
		isSystemUser = true;
	};

}

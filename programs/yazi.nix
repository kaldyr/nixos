{ pkgs, sysConfig, ... }: {

	environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [
			mediainfo
			ouch
		];

		programs.yazi = {

			enable = true;
			enableFishIntegration = true;

			plugins = let

				yazi-plugins = pkgs.fetchFromGitHub {
					owner = "yazi-rs";
					repo = "plugins";
					rev = "ad52adf917d6dd679dbc2dcefa3a9384654bd1c7";
					sha256 = "sha256-UOSH8RM+6VkQqi14bwUdFUNm8CgbDRlNial9VevjYuU=";
				};

			in {

				"chmod" = "${yazi-plugins}/chmod.yazi";
				"full-border" = "${yazi-plugins}/full-border.yazi";
				"hide-preview" = "${yazi-plugins}/hide-preview.yazi";
				"jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";

				"ouch" = pkgs.fetchFromGitHub {
					owner = "ndtoan96";
					repo = "ouch.yazi";
					rev = "v0.2.1";
					sha256 = "sha256-yLt9aY6hUIOdBI5bMdCs7VYFJGyD3WIkmPxvWKNCskA=";
				};

				"smart-filter" = "${yazi-plugins}/smart-filter.yazi";

				"starship" = pkgs.fetchFromGitHub {
					owner = "Rolv-Apneseth";
					repo = "starship.yazi";
					rev = "77a65f5a367f833ad5e6687261494044006de9c3";
					sha256 = "sha256-sAB0958lLNqqwkpucRsUqLHFV/PJYoJL2lHFtfHDZF8=";
				};

			};

		};

		xdg.configFile."yazi/init.lua".text = /* lua */ ''
			require( 'full-border' ):setup {
				type = ui.Border.ROUNDED,
			}
			require( 'starship' ):setup()
		'';

		xdg.configFile."yazi/keymap.toml".text = /* toml */ ''
			[manager]
			prepend_keymap = [
				{ on = "q", run = "close", desc = "Close the current tab, or quit if it is last tab" },
				{ on = [ "c", "m" ], run = "plugin chmod", desc = "Chmod on selected files" },
				{ on = "\\", run = "plugin --sync hide-preview", desc = "Toggle preview pane" },
				{ on = "`", run = "shell \"$SHELL\" --block --confirm", desc = "Open shell here" },
				{ on = "C", run = "plugin ouch --args=zip", desc = "Compress with ouch" },
				{ on = "f", run = "plugin jump-to-char", desc = "Jump to Char" },
				{ on = "F", run = "plugin smart-filter", desc = "Smart Filter" },
			]
		'';

		xdg.configFile."yazi/yazi.toml".text = let

			buildDevLayout = pkgs.writeShellScript "buildDevLayout.sh" /* bash */ ''
				cd $1
				tabname=''${PWD##*/}
				if [ ''${PWD} == "/nix/config" ]; then
				  tabname='NixOS'
				fi
				zellij --layout dev
				sleep 0.1
				zellij action move-focus down
				zellij action write-chars "++"
				zellij action move-focus up
				zellij action write-chars "\\"
				zellij action move-focus right
				zellij action rename-tab "$tabname"
				kill -s SIGQUIT $PPID
			'';

		in /* toml */ ''
			[manager]
			linemode = "size"
			mouse_events = [ "click", "scroll" ]
			ratio = [0, 1, 2]
			scrolloff = 5
			show_hidden = false
			show_symlink = true
			sort_by = "natural"
			sort_dir_first = true
			sort_reverse = false
			sort_sensitive = false
			sort_translit = false
			title_format = "Yazi: {cwd}"

			[preview]
			cache_dir = ""
			image_delay = 50
			image_filter = "triangle"
			image_quality = 75
			max_height = 900
			max_width = 600
			sixel_fraction = 15
			tab_size = 2
			ueberzug_offset = [ 0, 0, 0, 0 ]
			ueberzug_scale = 1
			wrap = "no"

			[plugin]
			prepend_previewers = [
				{ mime = "application/*zip", run = "ouch" },
				{ mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", run = "ouch" },
			]

			[opener]
			dev = [ { run = '${pkgs.bash}/bin/bash ${buildDevLayout} "$@"', desc = "IDE in new tab", orphan = true } ]
			edit = [ { run = 'nvim "$@"', desc = "Edit", block = true } ]
			exif = [ { run = 'exiftool "$1"; echo "Press enter to exit"; read _', desc = "Show EXIF data", block = true } ]
			exifedit = [
				{ run = 'exiftool -overwrite_original "-alldates<filename" -S -m -q "$1"', desc = "Set EXIF datetime from Filename" },
				{ run = 'exiftool "-filename<CreateDate" -d "_%Y%m%d_%H%M%S.%%e" -S -m -ee -q "$1"', desc = "Set Filename from EXIF datetime" },
			]
			extract = [ { run = 'ouch d -y "$@"', desc = "Extract Here with ouch" } ]
			foldersize = [ { run = 'du -hs "$@"; echo "Press enter to exit"; read _', desc = "Folder size", block = true } ]
			image = [ { run = 'feh -. -Z "$@"', desc = "Open with feh", orphan = true } ]
			office = [ { run = 'libreoffice "$@"', desc = "Open with LibreOffice", orphan = true } ]
			open = [ { run = 'xdg-open "$1"', desc = "XDG Open", orphan = true } ]
			pdf = [ { run = 'zathura "$@"', desc = "Open with Zathura", orphan = true } ]
			play = [
				{ run = 'mpv --force-window "$@"', desc = "Play with mpv", orphan = true },
				{ run = 'mediainfo "$1"; echo "Press enter to exit"; read _', desc = "Show media info", block = true },
			]

			[open]
			rules = [
				{ mime = "application/{,g}zip", use = [ "extract", "exif" ] },
				{ mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", use = [ "extract", "exif" ] },
				{ mime = "application/pdf", use = [ "pdf", "exif" ] },
				{ mime = "audio/*", use = [ "play", "exif" ] },
				{ mime = "image/*", use = [ "image", "exif", "exifedit" ] },
				{ mime = "inode/directory", use = [ "dev", "play", "foldersize" ] },
				{ mime = "text/*", use = [ "edit", "exif" ] },
				{ mime = "video/*", use = [ "play", "exif", "exifedit" ] },
				{ name = "*.od{g,p,s,t}", use = [ "office", "exif" ] },
				{ name = "*.doc{,x}", use = [ "office", "exif" ] },
				{ name = "*.ppt{,x}", use = [ "office", "exif" ] },
				{ name = "*.xls{,x}", use = [ "office", "exif" ] },
				{ mime = "*", use = [ "open", "edit", "exif" ] },
			]

			[tasks]
			micro_workers = 10
			macro_workers = 25
			bizarre_retry = 5
			image_alloc = 536870912  # 512MB
			image_bound = [ 0, 0 ]
			suppress_preload = false

			[log]
			enabled = false
		'';

	};

}

{ pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		programs.btop.enable = true;

		xdg.configFile."btop/btop.conf".text = /* bash */ ''
			clock_format = ""
			color_theme = "catppuccin_frappe.theme"
			disks_filter = "/ /boot /home /nix"
			log_level = "WARNING"
			proc_tree = True
			theme_background = False
			vim_keys = True
		'';

		xdg.configFile."btop/themes/catppuccin_frappe.theme".source = pkgs.fetchFromGitHub {
			owner = "catppuccin";
			repo = "btop";
			rev = "21b8d5956a8b07fa52519e3267fb3a2d2e693d17";
			sha256 = "sha256-UXeTypc15MhjgGUiCrDUZ40m32yH2o1N+rcrEgY6sME=";
		} + "/themes/catppuccin_frappe.theme";

		xdg.desktopEntries.btop = { name = "btop++"; noDisplay = true; };

	};

}

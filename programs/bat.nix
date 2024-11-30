{ pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		programs.bat.enable = true;

		xdg.configFile."bat/config".text = /* bash */ ''
			--theme='Catppuccin Frappe'
		'';

		xdg.configFile."bat/themes/Catppuccin Frappe.tmTheme".source = pkgs.fetchFromGitHub {
			owner = "catppuccin";
			repo = "bat";
			rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
			sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
		} + "/themes/Catppuccin Frappe.tmTheme";

	};

}

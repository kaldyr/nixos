{ lib, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		programs.wezterm.enable = true;

		xdg.configFile."wezterm/wezterm.lua".text = lib.mkForce /* lua */ ''
			local wezterm = require "wezterm"
			local config = {}

			if wezterm.config_builder then
				config = wezterm.config_builder()
			end

			config.animation_fps = 85
			config.adjust_window_size_when_changing_font_size = false
			config.bold_brightens_ansi_colors = true
			config.check_for_updates = false
			config.color_scheme = "Catppuccin Frappe"
			config.default_cursor_style = 'SteadyBar'
			config.enable_kitty_graphics = true
			config.enable_scroll_bar = false
			config.enable_wayland = true

			config.font = wezterm.font( 'Liga Rec Mono Custom' )
			config.cell_width = 1.0
			config.line_height = 1.1
			config.font_size = 11
			config.warn_about_missing_glyphs = false
			config.hide_mouse_cursor_when_typing = false
			config.hide_tab_bar_if_only_one_tab = true
			config.use_fancy_tab_bar = false

			config.disable_default_key_bindings = true
			config.keys = {
				{ key = '-', mods = 'ALT', action = wezterm.action.DecreaseFontSize },
				{ key = '=', mods = 'ALT', action = wezterm.action.IncreaseFontSize },
				{ key = 'u', mods = 'ALT', action = wezterm.action.CharSelect },
			}

			config.scrollback_lines = 10000
			config.use_dead_keys = false

			config.window_padding = {
				left = 0;
				right = 0;
				top = 0;
				bottom = 0;
			}

			return config
		'';

	};

}

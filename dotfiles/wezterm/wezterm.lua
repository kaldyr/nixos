local config = {}
local wezterm = require "wezterm"

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = false
config.animation_fps = 85
config.bold_brightens_ansi_colors = true
config.check_for_updates = false
config.color_scheme = "Catppuccin Frappe"
config.default_cursor_style = 'SteadyBar'
config.enable_kitty_graphics = true
config.enable_scroll_bar = false
config.enable_wayland = true
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000
config.use_dead_keys = false
config.use_fancy_tab_bar = false
config.warn_about_missing_glyphs = false

config.font_size = 12
config.cell_width = 1.0
config.line_height = 1.0

local juliamono_features = { 'cv02', 'cv03', 'ss04', 'ss08', 'ss12', 'ss13', 'ss14' }
local maplemono_features = { 'calt', 'cv03', 'ss01', 'ss03', 'ss07', 'ss08', 'zero' }

config.font_rules = {
	{
		intensity = 'Normal',
		italic = false,
		font = wezterm.font_with_fallback {
			{
				family = 'Maple Mono NF',
				harfbuzz_features = maplemono_features,
				style = 'Normal',
				weight = 'Regular',
			},
			{
				family = 'JuliaMono',
				harfbuzz_features = juliamono_features,
				style = 'Normal',
				weight = 'Medium',
			},
		},
	},
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font_with_fallback {
			{
				family = 'Maple Mono NF',
				harfbuzz_features = maplemono_features,
				style = 'Normal',
				weight = 'ExtraBold',
			},
			{
				family = 'JuliaMono',
				harfbuzz_features = juliamono_features,
				style = 'Normal',
				weight = 'Black',
			},
		},
	},
	{
		intensity = 'Normal',
		italic = true,
		font = wezterm.font_with_fallback {
			{
				family = 'Maple Mono NF',
				harfbuzz_features = maplemono_features,
				style = 'Italic',
				weight = 'Regular',
			},
			{
				family = 'JuliaMono',
				harfbuzz_features = juliamono_features,
				style = 'Italic',
				weight = 'Medium',
			},
		},
	},
	{
		intensity = 'Bold',
		italic = true,
		font = wezterm.font_with_fallback {
			{
				family = 'Maple Mono NF',
				harfbuzz_features = maplemono_features,
				style = 'Italic',
				weight = 'ExtraBold',
			},
			{
				family = 'JuliaMono',
				harfbuzz_features = juliamono_features,
				style = 'Italic',
				weight = 'Black',
			},
		},
	},
}

config.disable_default_key_bindings = true
config.keys = {
	{ key = '-', mods = 'ALT', action = wezterm.action.DecreaseFontSize },
	{ key = '=', mods = 'ALT', action = wezterm.action.IncreaseFontSize },
	{ key = '0', mods = 'ALT', action = wezterm.action.ResetFontSize },
	{ key = 'u', mods = 'ALT', action = wezterm.action.CharSelect },
	{ key = 'q', mods = 'ALT', action = wezterm.action.QuickSelect },
}

config.window_padding = {
	left = 0;
	right = 0;
	top = 0;
	bottom = 0;
}

return config

local wezterm = require 'wezterm'
local wa = wezterm.action
-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- local io = require 'io'
-- local os = require 'os'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
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
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.inactive_pane_hsb = { brightness = 0.7, saturation = 1.0 }
config.pane_focus_follows_mouse = true
config.scrollback_lines = 10000
config.show_tab_index_in_tab_bar = false
config.use_dead_keys = false
config.use_fancy_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_padding = { left = 0 ; right = 0 ; top = 0 ; bottom = 0 ; }

-- Fonts
config.font_size = 10.8
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

-- Functions for keybinds
-- wezterm.on( 'trigger-nvim-with-scrollback', function( window, pane )
--
-- 	local text = pane:get_lines_as_text( pane:get_dimensions().scrollback_rows )
-- 	local name = os.tmpname()
-- 	local f, err = assert( io.open( name, 'w+' ) )
--
-- 	if f then
--
-- 		f:write( text )
-- 		f:flush()
-- 		f:close()
--
-- 		window:perform_action(
-- 			wa.SpawnCommandInNewTab {
-- 				args = { 'nvim', name },
-- 			},
-- 			pane
-- 		)
--
-- 		wezterm.sleep_ms(1000)
-- 		os.remove(name)
--
-- 	else
-- 		print( 'Error opening scrollback' .. err )
-- 	end
--
-- end )

-- Keybinds
config.disable_default_key_bindings = true
config.keys = {
	{ key = '-', mods = 'ALT', action = wa.DecreaseFontSize },
	{ key = '=', mods = 'ALT', action = wa.IncreaseFontSize },
	{ key = '0', mods = 'ALT', action = wa.ResetFontSize },
	{ key = 'u', mods = 'ALT', action = wa.CharSelect },
	{ key = 'q', mods = 'ALT', action = wa.QuickSelect },
	-- { key = 's', mods = 'ALT', action = wa.PaneSelect { mode = 'SwapWithActiveKeepFocus', }, },
	-- { key = 'h', mods = 'ALT', action = wa.ActivatePaneDirection 'Left' },
	-- { key = 'j', mods = 'ALT', action = wa.ActivatePaneDirection 'Down' },
	-- { key = 'k', mods = 'ALT', action = wa.ActivatePaneDirection 'Up' },
	-- { key = 'l', mods = 'ALT', action = wa.ActivatePaneDirection 'Right' },
	-- { key = 'h', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Left' } ) },
	-- { key = 'j', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Down' } ) },
	-- { key = 'k', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Up' } ) },
	-- { key = 'l', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Right' } ) },
	-- { key = 'LeftArrow', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Left', top_level = true } ) },
	-- { key = 'DownArrow', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Down', top_level = true } ) },
	-- { key = 'UpArrow', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Up', top_level = true } ) },
	-- { key = 'RightArrow', mods = 'SHIFT|ALT', action = wa.SplitPane( { direction = 'Right', top_level = true } ) },
	-- { key = 'LeftArrow', mods = 'ALT', action = wa.AdjustPaneSize { 'Left', 1 } },
	-- { key = 'DownArrow', mods = 'ALT', action = wa.AdjustPaneSize { 'Down', 1 } },
	-- { key = 'UpArrow', mods = 'ALT', action = wa.AdjustPaneSize { 'Up', 1 } },
	-- { key = 'RightArrow', mods = 'ALT', action = wa.AdjustPaneSize { 'Right', 1 } },
	-- { key = 'f', mods = 'ALT', action = wa.TogglePaneZoomState },
	-- { key = 'x', mods = 'ALT', action = wa.CloseCurrentPane { confirm = true } },
	-- { key = 't', mods = 'ALT', action = wa.SpawnTab 'DefaultDomain' },
	-- { key = '.', mods = 'ALT', action = wa.ActivateTabRelative( 1 ) },
	-- { key = ',', mods = 'ALT', action = wa.ActivateTabRelative( -1 ) },
	-- { key = '>', mods = 'SHIFT|ALT', action = wa.MoveTabRelative( 1 ) },
	-- { key = '<', mods = 'SHIFT|ALT', action = wa.MoveTabRelative( -1 ) },
}

-- tabline.setup({
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = 'Catppuccin Frappe',
-- 		tabs_enabled = true,
-- 		color_overrides = {},
-- 		section_separators = {
-- 			left = '',
-- 			right = '',
-- 		},
-- 		component_separators = {
-- 			left = '',
-- 			right = '',
-- 		},
-- 		tab_separators = {
-- 			left = '',
-- 			right = '',
-- 		},
-- 	},
-- 	sections = {
-- 		tabline_a = { 'mode' },
-- 		tabline_b = { },
-- 		tabline_c = { },
-- 		tab_active = {
-- 			{ 'process', padding = 1 },
-- 			{ 'zoomed', padding = 0 },
-- 		},
-- 		tab_inactive = {
-- 			{ 'process', padding = 1 }
-- 		},
-- 		tabline_x = { },
-- 		tabline_y = { },
-- 		tabline_z = { 'domain' },
-- 	},
-- 	extensions = {},
-- })

return config

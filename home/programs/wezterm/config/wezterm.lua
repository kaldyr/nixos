local wezterm = require "wezterm"
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = true

config.color_scheme = "Catppuccin Frappe"

config.disable_default_key_bindings = true

config.enable_kitty_graphics = true
config.enable_scroll_bar = false

-- Temporary fix while Wez rebuilds wayland support
config.enable_wayland = false

config.font = wezterm.font { family = 'Recursive Mn Csl St' }
config.font_size = 9.0

config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 10000

config.use_dead_keys = false

config.window_padding = {
    left = 0;
    right = 0;
    top = 0;
    bottom = 0;
}

return config

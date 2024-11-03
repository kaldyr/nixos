{ lib, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.wezterm.enable = true;

        xdg.configFile."wezterm/wezterm.lua".text = lib.mkForce /* lua */ ''
            local wezterm = require "wezterm"
            local io = require 'io'
            local os = require 'os'
            local config = {}

            wezterm.on( 'trigger-nvim-with-scrollback', function( window, pane )

                local text = pane:get_lines_as_text( pane:get_dimensions().scrollback_rows )
                local name = os.tmpname()
                local f, err = assert( io.open( name, 'w+' ) )

                if f then

                    f:write( text )
                    f:flush()
                    f:close()

                    window:perform_action(
                        wezterm.action.SpawnCommandInNewTab {
                            args = { 'nvim', name },
                        },
                        pane
                    )

                    wezterm.sleep_ms(1000)
                    os.remove(name)

                else
                    print( 'Error opening scrollback' .. err )
                end

            end )

            if wezterm.config_builder then
                config = wezterm.config_builder()
            end

            config.animation_fps = 85
            config.adjust_window_size_when_changing_font_size = false
            config.color_scheme = "Catppuccin Frappe"
            config.default_cursor_style = 'SteadyBar'
            config.enable_kitty_graphics = true
            config.enable_scroll_bar = false
            config.enable_wayland = true

            config.font = wezterm.font({
                family = 'Recursive Mn Csl St',
                harfbuzz_features = {
                    '+dlig',
                    '+ss03',
                    '+ss04',
                    '+ss05',
                    '+ss06',
                    '+ss07',
                    '+ss08',
                    '+ss09',
                    '+ss10',
                    '+ss11',
                    '+ss12',
                    '+case',
                    '+liga',
                    '+afrc',
                }
            })

            config.cell_width = 1.0
            config.font_size = 9.5
            config.warn_about_missing_glyphs = false
            config.hide_mouse_cursor_when_typing = false
            config.hide_tab_bar_if_only_one_tab = true
            config.use_fancy_tab_bar = false
            config.hyperlink_rules = wezterm.default_hyperlink_rules()
            config.pane_focus_follows_mouse = true
            config.show_tab_index_in_tab_bar = false

            config.inactive_pane_hsb = {
                brightness = 0.7,
            }

            config.disable_default_key_bindings = true
            config.keys = {
                { key = '-', mods = 'ALT', action = wezterm.action.DecreaseFontSize },
                { key = '=', mods = 'ALT', action = wezterm.action.IncreaseFontSize },
                { key = 'y', mods = 'ALT', action = wezterm.action.QuickSelect },
                { key = 'u', mods = 'ALT', action = wezterm.action.CharSelect },
                { key = 'e', mods = 'ALT', action = wezterm.action.EmitEvent 'trigger-nvim-with-scrollback' },
                { key = 'p',
                    mods = 'ALT',
                    action = wezterm.action.ActivateKeyTable {
                        name = 'create_pane',
                        timeout_milliseconds = 5000,
                    },
                },
                { key = 's',
                    mods = 'ALT',
                    action = wezterm.action.PaneSelect {
                        mode = 'SwapWithActiveKeepFocus',
                    },
                },
                { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
                { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
                { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
                { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
                { key = 'LeftArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
                { key = 'DownArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
                { key = 'UpArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
                { key = 'RightArrow', mods = 'ALT', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
                { key = 'f', mods = 'ALT', action = wezterm.action.TogglePaneZoomState },
                { key = 'x', mods = 'ALT', action = wezterm.action.CloseCurrentPane { confirm = true } },
                { key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'DefaultDomain' },
                { key = '.', mods = 'ALT', action = wezterm.action.ActivateTabRelative( 1 ) },
                { key = ',', mods = 'ALT', action = wezterm.action.ActivateTabRelative( -1 ) },
                { key = '>', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative( 1 ) },
                { key = '<', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative( -1 ) },
                { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab( 0 ) },
                { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab( 1 ) },
                { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab( 2 ) },
                { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab( 3 ) },
                { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab( 4 ) },
                { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab( 5 ) },
                { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab( 6 ) },
                { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab( 7 ) },
                { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab( 8 ) },
                { key = '0', mods = 'ALT', action = wezterm.action.ActivateTab( 9 ) },
            }

            config.key_tables = {
                create_pane = {
                    { key = 'Escape', action = "PopKeyTable" },
                    { key = 'Enter', action = "PopKeyTable" },
                    { key = 'h',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Left',
                                size = { Percent = 50 },
                            }
                        )
                    },
                    { key = 'j',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Down',
                                size = { Percent = 50 },
                            }
                        )
                    },
                    { key = 'k',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Up',
                                size = { Percent = 50 },
                            }
                        )
                    },
                    { key = 'l',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Right',
                                size = { Percent = 50 },
                            }
                        )
                    },
                    { key = 'LeftArrow',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Left',
                                size = { Percent = 50 },
                                top_level = true,
                            }
                        )
                    },
                    { key = 'DownArrow',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Down',
                                size = { Percent = 50 },
                                top_level = true,
                            }
                        )
                    },
                    { key = 'UpArrow',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Up',
                                size = { Percent = 50 },
                                top_level = true,
                            }
                        )
                    },
                    { key = 'RightArrow',
                        action = wezterm.action.SplitPane(
                            {
                                direction = 'Right',
                                size = { Percent = 50 },
                                top_level = true,
                            }
                        )
                    },
                }
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

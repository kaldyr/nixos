-- Config --
-- Startup         -->
---------------------
-- vim:fdm=marker:fdl=0:foldmarker=-->,<--

-- Get the hostname for machine specific configs
local hostname = ''
do
	local f = io.popen ('hostname')
	if f ~= nil then
		hostname = f:read('*a') or ''
		f:close()
	end
end
hostname = string.gsub(hostname, '\n$', '')

-- Startup applications
local launch = hl.exec_cmd
hl.on( 'hyprland.start', function()

	launch 'wl-paste --type text --watch cliphist store'
	launch 'wl-paste --type image --watch cliphist store'
	launch 'nm-applet'
	launch 'tailscale systray'

	if hostname == 'espresso' then
		launch 'wayland-push-to-talk-fix -k "grave" -n "grave" /dev/input/by-id/usb-04d9_daskeyboard-event-kbd'

	elseif hostname == 'mjolnir' then
		launch 'wayland-push-to-talk-fix -k "BTN_MIDDLE" -n "XF86WheelButton" /dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse'
		launch 'nmcli radio wifi off'
	end

end )

--<------------------
-- Monitors & Gaps -->
---------------------

-- Main monitor

local usable_scales = { '1.0' }
if hostname == 'espresso' then

	hl.monitor({
		output = 'HDMI-A-1',
		mode   = '1920x1080@60',
		position = 'auto',
		scale = '1.0',
	})

	hl.config({ general = {
		gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
		gaps_out = { top = 8, left = 18, right = 18, bottom = 18 }, -- 20
	} })

elseif hostname == 'hofud' then

	usable_scales = {
		'1.0',                -- 2256x1504
		'1.1749999523162842', -- 1920x1280
		'1.3333333730697632', -- 1692x1128
		-- '1.5666667222976685', -- 1437x958 really close to next step
		'1.6000000238418579', -- 1410x940
		-- '1.9583333730697632', -- 1151x767 really close to next step
		'2.0',                -- 1128x752
	}

	hl.monitor({
		output = 'eDP-1',
		mode   = '2256x1504@60',
		position = 'auto',
		scale = '1.3333333730697632',
	})

	hl.monitor({
		output = '',
		mode   = '3440x1440@85',
		position = '0x0',
		scale = '1.0',
		bitdepth = 10,
		sdrbrightness = 1.2,
		sdrsaturation = 0.98,
	})

	hl.config({ general = {
		gaps_in  = { top = 8, left = 14, right = 14, bottom = 9 }, -- 5
		gaps_out = { top = 8, left = 20, right = 20, bottom = 24 }, -- 20
	} })

	hl.on( 'monitor.added', function()
		local monitors = hl.get_monitors() or ''
		if #monitors == 1 and monitors[1].name == 'FALLBACK' then
			hl.config({ general = {
				gaps_in  = { top = 8, left = 14, right = 14, bottom = 9 }, -- 5
				gaps_out = { top = 8, left = 20, right = 20, bottom = 24 }, -- 20
			} })
			return
		end
		for _, mon in pairs(monitors) do
			if mon.size.width == 3440 then -- Disable the internal screen if the ultrawide is plugged in
				usable_scales = { '1.0' }
				hl.monitor({ output = 'eDP-1', disabled = true })
				hl.config({ general = {
					gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
					gaps_out = { top = 8, left = 18, right = 18, bottom = 18 }, -- 20
				} })
			end
		end
	end )

	hl.on( 'monitor.removed', function()
		local monitors = hl.get_monitors() or ''
		if #monitors == 0 then
			usable_scales = {
				'1.0',                -- 2256x1504
				'1.1749999523162842', -- 1920x1280
				'1.3333333730697632', -- 1692x1128
				-- '1.5666667222976685', -- 1437x958 really close to next step
				'1.6000000238418579', -- 1410x940
				-- '1.9583333730697632', -- 1151x767 really close to next step
				'2.0',                -- 1128x752
			}
			hl.monitor({
				output = 'eDP-1',
				mode   = '2256x1504@60',
				position = 'auto',
				scale = '1.3333333730697632',
				disabled = false,
			})
		end
	end )

elseif hostname == 'mjolnir' then

	hl.monitor({
		output = 'HDMI-A-1',
		mode   = '3440x1440@85',
		position = 'auto',
		scale = '1.0',
		bitdepth = 10,
		sdrbrightness = 1.2,
		sdrsaturation = 0.98,
	})

	hl.config({ general = {
		gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
		gaps_out = { top = 8, left = 18, right = 18, bottom = 18 }, -- 20
	} })

end

--<------------------
-- Environment     -->
---------------------

hl.env( 'ELECTRON_OZONE_PLATFORM_HINT', 'wayland' )
hl.env( 'HYPRCURSOR_SIZE', '24' )
hl.env( 'HYPRCURSOR_THEME', 'catppuccin-frappe-sapphire-cursors' )
hl.env( 'NIXOS_OZONE_WL', '1' )
hl.env( 'PROTON_ENABLE_WAYLAND', '1' )
hl.env( 'WLR_NO_HARDWARE_CURSORS', '1' )
hl.env( 'XCURSOR_SIZE', '24' )

--<------------------
-- General         -->
---------------------

local vrr = 0
if hostname == 'mjolnir' or hostname == 'espresso' then vrr = 1 end

hl.config({

	dwindle = {
		preserve_split = true,
	},

	ecosystem = {
		no_donation_nag = true, -- false
		no_update_news = true, -- false
	},

	general = {
		border_size = 1, -- 1

		col = {
			active_border = {
				colors = { 0xee85c1dc, 0xee81c8be }, -- 0xffffffff
				angle = 45,
			},
			inactive_border = 0x8885c1dc, -- 0xff444444
		},

		layout           = 'dwindle', -- dwindle
		resize_on_border = false, -- false
	},

	misc = {
		disable_hyprland_logo   = true, -- false
		force_default_wallpaper = 0, -- -1
		vrr                     = vrr, -- 0
	},

})

--<------------------
-- Appearance      -->
---------------------

hl.config({

	decoration = {

		active_opacity        = 1.0, -- 1.0
		fullscreen_opacity    = 1.0, -- 1.0
		inactive_opacity      = 0.9, -- 1.0
		border_part_of_window = true, -- true
		dim_around            = 0.4, -- 0.4
		dim_inactive          = true, -- false
		dim_modal             = true, -- true
		dim_special           = 0.2, -- 0.2
		dim_strength          = 0.15, -- 0.5
		rounding              = 16, -- 0
		rounding_power        = 5, -- 2.0

		blur = {
			enabled            = true, -- true
			brightness         = 0.8172, -- 0.8172
			contrast           = 0.8916, -- 0.8916
			ignore_opacity     = true, -- true
			new_optimizations  = true, -- true
			noise              = 0.05, -- 0.0117
			passes             = 3, -- 1
			popups             = false, -- false
			popups_ignorealpha = 0.2, -- 0.2
			size               = 20, -- 8
			special            = false, -- false
			vibrancy           = 0.5, -- 0.1696
			vibrancy_darkness  = 0.9, -- 0.0
			xray               = false, -- false
		},

		glow = {
			enabled      = false, -- false
			color        = 0x5a81c8be, -- 0xee1a1a1a
			range        = 8, -- 10
			render_power = 3, -- 3
		},

		shadow = {
			enabled      = true, -- true
			color        = 0xee232634, -- 0xee1a1a1a
			range        = 4, -- 4
			render_power = 3, -- 3
			sharp        = false, -- false
		},

	},

	misc = {
		font_family = 'Maple Mono NF',
	},

})

--<------------------
-- Animations      -->
---------------------

hl.config({
	animations = {
		enabled              = true, -- false
		workspace_wraparound = false, -- false
	},
	misc = {
		animate_manual_resizes       = true, -- false
		animate_mouse_windowdragging = true, -- false
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve('easeOutQuint',   { type = 'bezier', points = { {0.23, 1},    {0.32, 1} } })
hl.curve('easeInOutCubic', { type = 'bezier', points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve('linear',         { type = 'bezier', points = { {0, 0},       {1, 1}    } })
hl.curve('almostLinear',   { type = 'bezier', points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve('quick',          { type = 'bezier', points = { {0.15, 0},    {0.1, 1}  } })

-- Default springs
hl.curve('easy', { type = 'spring', mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = 'global',        enabled = true, speed = 10,   bezier = 'default' })
hl.animation({ leaf = 'border',        enabled = true, speed = 5.39, bezier = 'easeOutQuint' })
hl.animation({ leaf = 'windows',       enabled = true, speed = 4.79, spring = 'easy' })
hl.animation({ leaf = 'windowsIn',     enabled = true, speed = 4.1,  spring = 'easy',         style = 'popin 87%' })
hl.animation({ leaf = 'windowsOut',    enabled = true, speed = 1.49, bezier = 'linear',       style = 'popin 87%' })
hl.animation({ leaf = 'fadeIn',        enabled = true, speed = 1.73, bezier = 'almostLinear' })
hl.animation({ leaf = 'fadeOut',       enabled = true, speed = 1.46, bezier = 'almostLinear' })
hl.animation({ leaf = 'fade',          enabled = true, speed = 3.03, bezier = 'quick' })
hl.animation({ leaf = 'layers',        enabled = true, speed = 3.81, bezier = 'easeOutQuint' })
hl.animation({ leaf = 'layersIn',      enabled = true, speed = 4,    bezier = 'easeOutQuint', style = 'fade' })
hl.animation({ leaf = 'layersOut',     enabled = true, speed = 1.5,  bezier = 'linear',       style = 'fade' })
hl.animation({ leaf = 'fadeLayersIn',  enabled = true, speed = 1.79, bezier = 'almostLinear' })
hl.animation({ leaf = 'fadeLayersOut', enabled = true, speed = 1.39, bezier = 'almostLinear' })
hl.animation({ leaf = 'workspaces',    enabled = true, speed = 1.94, bezier = 'almostLinear', style = 'slidefade' })
hl.animation({ leaf = 'workspacesIn',  enabled = true, speed = 1.21, bezier = 'almostLinear', style = 'slidefade' })
hl.animation({ leaf = 'workspacesOut', enabled = true, speed = 1.94, bezier = 'almostLinear', style = 'slidefade' })
hl.animation({ leaf = 'zoomFactor',    enabled = true, speed = 7,    bezier = 'quick' })

--<------------------
-- Input           -->
---------------------
hl.config({
	input = {
		follow_mouse = 2,
		kb_layout  = 'us',
		kb_variant = '',
		kb_model   = '',
		kb_options = '',
		kb_rules   = '',
		sensitivity = 0, -- 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = 'horizontal',
	action = 'workspace'
})

--<------------------
-- Keybindings     -->
---------------------

-- Shorthand
local b, e = hl.bind, hl.dsp.exec_cmd
local m, s, c, a = 'SUPER + ', 'SHIFT + ', 'CTRL + ', 'ALT + '

-- Size functions
local function win_large_size()
	local mon = hl.get_active_monitor() or ''

	local w, h = 1394, 1031 -- Default
	if mon.width == 3440 or hostname == 'mjolnir' then
		w, h = 1080, 855
	end

	return { w, h }
end

local function win_small_size()
	local mon = hl.get_active_monitor() or ''

	local w, h = 487, 319
	if mon.width == 3440 or hostname == 'mjolnir' then
		w, h = 480, 323
	end

	return { w, h }
end

-- Launchers
b( m..'b',    e('kitty --session ~/.config/kitty/sessions/btop.kitty-session', { float = true, size = win_large_size() }) )
b( m..'c',    e('kitty --session ~/.config/kitty/sessions/qalc.kitty-session', { float = true, size = win_small_size() }) )
b( m..s..'c', e('kitty --session ~/.config/kitty/sessions/nixos.kitty-session', { float = true, size = win_large_size() }) )
b( m..'o',    e('kitty --session ~/.config/kitty/sessions/notes.kitty-session', { float = true, size = win_large_size() }) )
b( m..'y',    e('kitty --session ~/.config/kitty/sessions/yazi.kitty-session', { float = true, size = win_large_size() }) )
b( m..'m',    e 'keepmenu' )
b( m..'q',    e 'kitty' )
b( m..s..'q', e('kitty', { float = true, size = win_large_size() }) )
b( m..'r',    e 'fuzzel' )
b( m..'u',    e 'hyprpicker -a' )

-- Screen Capture
b( 'PRINT', e 'wlr-which-key --initial-keys "Print"' )

-- Play Media
b( m..'g', e '/nix/config/scripts/yt-dlp.sh' )

-- Notification Controls
b( m..'n', e 'wlr-which-key --initial-keys "n"' )

-- Use dotool to paste into things that do not like to obey paste keybinds
b( m..'v', e 'dotool $(cliphist list | fuzzel -d | cliphist decode)' )

-- Arrange windows into columns for ultrawide monitor or resize and center floating window
b( m..'a', function() -->

	local ws  = hl.get_workspace( hl.get_active_workspace() or '' )
	local mon = hl.get_active_monitor() or ''

	-- Bail if you didn't get a monitor or workspace
	if ws == nil or mon == nil then return end

	local floating, tiled = {}, {}
	for _, w in ipairs( hl.get_workspace_windows(ws) ) do
		if not w.floating and not w.hidden and w.at.y < 80  then
			tiled[ #tiled + 1 ] = w
		elseif w.floating and not w.hidden then
			floating[ #floating + 1 ] = w
		end
	end

	-- Deal with floating
	if #floating > 4 then return -- You're on your own
	elseif #floating == 1 then
		local size = win_large_size()
		if floating[1].size.x < 500 then
			size = win_small_size()
		end
		hl.dispatch( hl.dsp.window.resize({
			window = floating[1],
			x = size[1],
			y = size[2],
			relative = false,
		}) )
		hl.dispatch( hl.dsp.window.center({ window = floating[1] }))
	else
		table.sort( floating, function(i, j) return i.at.x < j.at.x end ) -- In order of position ltr
		local i = 1
		for _, w in ipairs(floating) do
			local size = win_large_size()
			if w.size.x < 500 then
				size = win_small_size()
			end
			hl.dispatch( hl.dsp.window.resize({
				window = w,
				x = size[1],
				y = size[2],
				relative = false,
			}) )
			hl.dispatch( hl.dsp.window.move({
				window = w,
				x = math.floor( (mon.width*i/#floating/mon.scale) - (mon.width/#floating/2/mon.scale) - (size[1]/2) ),
				y = math.floor( (mon.height/2/mon.scale) - (size[2] / 2) ),
				relative = false,
			}) )
			i = i + 1
		end
	end

	-- Deal with tiled
	-- Only continue if there are 2 or 3 columns of windows
	if #tiled == 1 then
		local w = tiled[1]
		local size = win_large_size()
		if w.size.x < 500 then
			size = win_small_size()
		end
		hl.dispatch( hl.dsp.window.resize({
			window = w,
			x = size[1],
			y = size[2],
			relative = false,
		}) )
	end
	if #tiled < 2 or #tiled > 3 then return end

	local go    = hl.get_config('general.gaps_out')
	local gi    = hl.get_config('general.gaps_in')
	local bsize = hl.get_config('general.border_size')

	table.sort( tiled, function(i, j) return i.at.x < j.at.x end ) -- In order of position ltr

	-- Window width
	local width   = math.floor( ((mon.width / mon.scale)*10 + 0.5)/10 ) -- Resolution adjusted by scale
	width = width - go.left - go.right - (bsize * 2) -- One set of outer gaps and border
	width = width - (gi.left + gi.right + (bsize * 2)) * ( #tiled - 1 ) -- Sets of inner gaps and borders
	width = width / #tiled -- Split the total window width by number of columns

	if #tiled == 2 then
		-- Toggle between { 50/50, 33/67, 67/33 }
		local newWidth = width
		local narrow   = math.floor( width * 2 / 3 ) + 3 -- [INFO] + 3 is to make window align to terminal col width
		local wide     = math.floor( width * 4 / 3 ) - 2 -- [INFO] - 2 is to make window align to terminal col width

		if tiled[1].size.x < tiled[2].size.x then
			newWidth = wide
		elseif tiled[1].size.x == tiled[2].size.x then
			newWidth = narrow
		end
		hl.dispatch( hl.dsp.window.resize({
			window = tiled[1],
			x = newWidth,
			y = tiled[1].size.y,
			relative = false,
		}) )
	elseif #tiled == 3 then
		-- Align into 3 equal (almost, center window is 1px narrower) columns for ultrawide
		if tiled[3].size.x > width then
			hl.dispatch( hl.dsp.window.move({ window = tiled[3], direction = 'r' }) )
		end
		hl.dispatch( hl.dsp.window.resize({
			window = tiled[1],
			x = math.ceil( width ),
			y = tiled[1].size.y,
			relative = false,
		}) )
		hl.dispatch( hl.dsp.window.resize({
			window = tiled[3],
			x = 5,
			y = 0,
			relative = true,
		}) )
	end

end ) --<--

-- Media controls
b( 'XF86AudioRaiseVolume',    e 'pamixer -i 1',                  { locked = true, repeating = true } )
b( 'XF86AudioLowerVolume',    e 'pamixer -d 1',                  { locked = true, repeating = true } )
b( 'XF86AudioMute',           e 'pamixer -t',                    { locked = true } )
b( s..'XF86AudioRaiseVolume', e 'pamixer --default-source -i 1', { locked = true, repeating = true } )
b( s..'XF86AudioLowerVolume', e 'pamixer --default-source -d 1', { locked = true, repeating = true } )
b( s..'XF86AudioMute',        e 'pamixer --default-source -t',   { locked = true } )
b( 'XF86AudioMicMute',        e 'pamixer --default-source -t',   { locked = true } )
b( 'XF86AudioNext',           e 'playerctl next',                { locked = true } )
b( 'XF86AudioPlay',           e 'playerctl play-pause',          { locked = true } )
b( 'XF86AudioPause',          e 'playerctl play-pause',          { locked = true } )
b( 'XF86AudioPrev',           e 'playerctl previous',            { locked = true } )

-- Brightness & Temperature
b( 'XF86MonBrightnessUp',      e 'brightnessctl set +5%',               { locked = true, repeating = true } )
b( 'XF86MonBrightnessDown',    e 'brightnessctl set -5%',               { locked = true, repeating = true } )
b( s..'XF86MonBrightnessUp',   e 'hyprctl hyprsunset temperature +500', { locked = true, repeating = true } )
b( s..'XF86MonBrightnessDown', e 'hyprctl hyprsunset temperature -500', { locked = true, repeating = true } )
b( m..'XF86MonBrightnessUp',   e 'hyprctl hyprsunset temperature 3500', { locked = true } )
b( m..'XF86MonBrightnessDown', e 'hyprctl hyprsunset identity',         { locked = true } )

-- Monitor Scaling
b( m..'equal', function() -->
	if #usable_scales == 1 then return end
	local mon = hl.get_active_monitor() or ''
	local new_scale = '1.0'
	for k,v in pairs(usable_scales) do
		if tostring(v) == tostring(mon.scale) then
			if k == #usable_scales then return
			else new_scale = usable_scales[ k + 1 ]
			end
		end
	end
	local cmd  = 'hyprctl eval "hl.monitor({ '
	cmd = cmd .. 'output=\\"' .. mon.name .. '\\", '
	cmd = cmd .. 'mode=\\"' .. mon.width .. 'x' .. mon.height .. '@' .. mon.refresh_rate .. '\\", '
	cmd = cmd .. 'position=\\"' .. mon.position.x .. 'x' .. mon.position.y .. '\\", '
	cmd = cmd .. 'scale=\\"' .. new_scale .. '\\" })"'
	hl.dispatch( e(cmd) )
	hl.notification.create({ text = mon.name .. ' scale: ' .. string.format( '%.3f', new_scale ), duration = 2500 })
end ) --<--
b( m..'minus', function() -->
	if #usable_scales == 1 then return end
	local mon = hl.get_active_monitor() or ''
	local new_scale = '1.0'
	for k,v in pairs(usable_scales) do
		if tostring(v) == tostring(mon.scale) then
			if k == 1 then return
			else new_scale = usable_scales[ k - 1 ]
			end
		end
	end
	local command      = 'hyprctl eval "hl.monitor({ '
	command = command .. 'output=\\"' .. mon.name .. '\\", '
	command = command .. 'mode=\\"' .. mon.width .. 'x' .. mon.height .. '@' .. mon.refresh_rate .. '\\", '
	command = command .. 'position=\\"' .. mon.position.x .. 'x' .. mon.position.y .. '\\", '
	command = command .. 'scale=\\"' .. new_scale .. '\\" })"'
	hl.dispatch( e(command) )
	hl.notification.create({ text = mon.name .. ' scale: ' .. string.format( '%.3f', new_scale ), duration = 2500 })
end ) --<--

-- Hyprland Controls
b( m..'x',         hl.dsp.window.close() )
b( m..'w',         hl.dsp.window.float({ action = 'toggle' }) )
b( m..'p',         function() -->
	local w = hl.get_active_window() or ''
	if w.floating then
		hl.dispatch( hl.dsp.window.float({ action = 'toggle' }) )
	end
	hl.dispatch( hl.dsp.window.pseudo() )
end ) --<--
b( m..'f',         hl.dsp.window.fullscreen() )
b( m..'s',         hl.dsp.layout("togglesplit") )
b( m..'Tab',       function() -->
	hl.dispatch( hl.dsp.window.cycle_next() )
	hl.dispatch( hl.dsp.window.bring_to_top() )
end ) --<--
b( m..'backslash', function() -->
	hl.dispatch( e 'hyprctl reload' )
	hl.dispatch( e 'systemctl --user restart waybar' )
end ) --<--

-- Which Key (Show all the keybinds)
b( m..'space', e 'wlr-which-key' )

-- Power Menu
b( m..'BackSpace', e 'wlr-which-key --initial-keys "BackSpace"' )

-- Focus Windows
b( m..'h', hl.dsp.focus({ direction = 'l' }) )
b( m..'j', hl.dsp.focus({ direction = 'd' }) )
b( m..'k', hl.dsp.focus({ direction = 'u' }) )
b( m..'l', hl.dsp.focus({ direction = 'r' }) )

-- Move Windows
b( m..s..'h',      hl.dsp.window.move({ direction = 'l' }) )
b( m..s..'j',      hl.dsp.window.move({ direction = 'd' }) )
b( m..s..'k',      hl.dsp.window.move({ direction = 'u' }) )
b( m..s..'l',      hl.dsp.window.move({ direction = 'r' }) )
b( m..'mouse:272', hl.dsp.window.drag(), { mouse = true } )

-- Resize Windows
b( m..s..'r',      e 'wlr-which-key --initial-keys "R"' )
b( m..'left',      hl.dsp.window.resize({ x = -24, y = 0,   relative = true}), { repeating = true } ) -- width of one terminal col
b( m..'down',      hl.dsp.window.resize({ x = 0,   y = 19,  relative = true}), { repeating = true } ) -- height of one terminal row
b( m..'up',        hl.dsp.window.resize({ x = 0,   y = -19, relative = true}), { repeating = true } ) -- height of one terminal row
b( m..'right',     hl.dsp.window.resize({ x = 24,  y = 0,   relative = true}), { repeating = true } ) -- width of one terminal col
b( m..s..'left',   hl.dsp.window.resize({ x = -1,  y = 0,   relative = true}), { repeating = true } )
b( m..s..'down',   hl.dsp.window.resize({ x = 0,   y = 1,   relative = true}), { repeating = true } )
b( m..s..'up',     hl.dsp.window.resize({ x = 0,   y = -1,  relative = true}), { repeating = true } )
b( m..s..'right',  hl.dsp.window.resize({ x = 1,   y = 0,   relative = true}), { repeating = true } )
b( m..'mouse:273', hl.dsp.window.resize(), { mouse = true } )
-- Switch Workspace
b( m..'code:59',    hl.dsp.focus({ workspace = 'e-1' }) ) -- ,
b( m..'code:60',    hl.dsp.focus({ workspace = 'e+1' }) ) -- .
b( m..'mouse_down', hl.dsp.focus({ workspace = 'e-1' }) )
b( m..'mouse_up',   hl.dsp.focus({ workspace = 'e+1' }) )
for i = 1, 10 do
	b( m..tostring(i % 10),    hl.dsp.focus({ workspace = i }) )
	b( m..s..tostring(i % 10), hl.dsp.window.move({ workspace = i, follow = false }) )
end

--<------------------
-- Window Rules    -->
---------------------

-- General         --

local wr = hl.window_rule
local suppressMaximizeRule = wr({
	name = 'suppress-maximize-events',
	match = { class = '.*' },
	suppress_event = 'maximize',
})
suppressMaximizeRule:set_enabled(true)

wr({
	name  = 'fix-xwayland-drags',
	match = {
		class      = '^$',
		title      = '^$',
		xwayland   = true,
		float      = true,
		fullscreen = false,
		pin        = false,
	},
	no_focus = true,
})

-- Specific     --

wr({ -- Age of Empires Online (Celeste Fan Project) Launcher
	name         = 'aoeo-launch',
	match        = { title = '^(celeste launcher.exe)$' },
	border_size  = 0,
	float        = true,
	no_blur      = true,
	no_shadow    = true,
	opaque       = true,
	stay_focused = false,
})

wr({ -- Age of Empires Online (Celeste Fan Project)
	name             = 'aoeo',
	match            = { title = '^(spartan.exe)$' },
	border_size      = 0,
	content          = 'game',
	no_blur          = true,
	no_shadow        = true,
	opaque           = true,
	render_unfocused = true,
	stay_focused     = false,
})

wr({ -- Battle.net Launcher
	name             = 'battle-net',
	match            = { class = '^(battle.net.exe)$' },
	border_size      = 0,
	float            = true,
	no_blur          = true,
	no_shadow        = true,
	opaque           = true,
})

wr({ -- Diablo II Resurrected
	name             = 'diablo-ii',
	match            = { title = '^(d2r.exe)$' },
	border_size      = 0,
	content          = 'game',
	no_blur          = true,
	no_shadow        = true,
	opaque           = true,
	pseudo           = true,
	render_unfocused = true,
	rounding         = 6,
	stay_focused     = false,
	suppress_event   = 'fullscreen maximize',
})

wr({ -- Discord
	name         = 'discord',
	match        = { class = 'discord' },
	allows_input = true,
	opacity      = '0.9',
})

wr({ -- System Tray Icon for Wine Applications
	name        = 'explorer-exe',
	match       = { class = '^(explorer.exe)$' },
	border_size = 1,
	float       = true,
	move        = '{0, 0}',
	no_blur     = false,
	no_shadow   = true,
	opaque      = true,
	rounding    = 10,
	size        = '{20, 20}',
})

wr({
	name    = 'feh',
	match   = { class = 'feh' },
	content = 'photo',
	pseudo  =  true,
})

wr({ -- Guild Wars 2
	name             = 'guild-wars-2',
	match            = { title = '^(Guild Wars 2)$' },
	border_size      = 0,
	content          = 'game',
	float            = true,
	no_blur          = true,
	no_shadow        = true,
	opaque           = true,
	render_unfocused = true,
	rounding         = 6,
	stay_focused     = false,
	suppress_event   = 'fullscreen maximize',
})

wr({ name = 'helium', match = { class = 'helium' }, opacity = '0.9' })
wr({ name = 'kitty', match = { class = 'kitty' }, opacity = '0.85' })
wr({ name = 'satty', match = { class = 'com.gabm.satty' }, float = true })
wr({ name = 'steam',  match = { class = 'steam$' }, opacity = '0.85' })

wr({ -- Steam game
	name        = 'steam-app',
	match       = { class = 'steam_app_.*' },
	border_size = 0,
	content     = 'game',
	float       = true,
	no_blur     = true,
	no_shadow   = true,
	opaque      = true,
})

wr({
	name = 'telegram',
	match = { class = '.*telegram.*' },
	opacity = '0.85',
	size = win_large_size()
})

wr({
	name = 'wlr-which-key',
	match = { class = 'wlr-which-key' },
	opacity = '0.85',
})

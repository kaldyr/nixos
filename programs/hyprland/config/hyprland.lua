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
local exe = hl.exec_cmd
hl.on( 'hyprland.start', function()

	exe 'systemctl --user start wallpaper-change.timer'
	exe 'wl-paste --type text --watch cliphist store'
	exe 'wl-paste --type image --watch cliphist store'
	exe 'waybar'
	exe 'nm-applet'
	exe 'tailscale systray'

	if hostname == 'espresso' then
		exe 'wayland-push-to-talk-fix -k "grave" -n "grave" /dev/input/by-id/usb-04d9_daskeyboard-event-kbd'

	elseif hostname == 'hofud' then
		exe 'pamixer -m'

	elseif hostname == 'mjolnir' then
		exe 'wayland-push-to-talk-fix -k "BTN_MIDDLE" -n "XF86WheelButton" /dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse'
		exe 'nmcli radio wifi off'
		exe 'pamixer --default-source -m'

	end

end )

--<------------------
-- Monitors        -->
---------------------

-- Main monitor

if hostname == 'espresso' then
	hl.monitor({
		output = 'HDMI-A-1',
		mode   = '1920x1080@60',
		position = 'auto',
		scale = 1,
	})

elseif hostname == 'hofud' then
	hl.monitor({
		output = 'eDP-1',
		mode   = '2256x1504@60',
		position = '0x0',
		scale = 1.175000,
	})

elseif hostname == 'mjolnir' then
	hl.monitor({
		output = 'HDMI-A-1',
		mode   = '3440x1440@84.97900',
		position = 'auto',
		scale = 1,
		bitdepth = 10,
		sdrbrightness = 1.2,
		sdrsaturation = 0.98,
	})

end

hl.monitor({ output = '', mode = 'preferred', position = 'auto', scale = 1 })

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

		gaps_in  = 12, -- 5
		gaps_out = {
			top = 8,
			left = 18,
			right = 18,
			bottom = 18,
		}, -- 20

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
-- Layout          -->
---------------------

hl.config({
	dwindle = {
		preserve_split = true,
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
		dim_inactive          = false, -- false
		dim_modal             = true, -- true
		dim_special           = 0.2, -- 0.2
		rounding              = 16, -- 0
		rounding_power        = 2.0, -- 2.0

		blur = {
			enabled            = true, -- true
			brightness         = 0.8172, -- 0.8172
			contrast           = 0.8916, -- 0.8916
			ignore_opacity     = true, -- true
			new_optimizations  = true, -- true
			noise              = 0.0117, -- 0.0117
			passes             = 3, -- 1
			popups             = false, -- false
			popups_ignorealpha = 0.2, -- 0.2
			size               = 12, -- 8
			special            = false, -- false
			vibrancy           = 0.1696, -- 0.1696
			vibrancy_darkness  = 0.0, -- 0.0
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

-- Shorthand for functions
local b, e = hl.bind, hl.dsp.exec_cmd

-- Shorthand for modifiers:  m = meta, s = shift, ms = meta + shift
local m  = function(key) return 'SUPER + ' .. key end
local s  = function(key) return 'SHIFT + ' .. key end
local ms = function(key) return 'SUPER + SHIFT + ' .. key end

-- Dimensions based on monitor, scale, and gaps for terminal applications
local term_row_height = 19
local term_col_width  = 24

-- Height of a terminal that factors in terminal line height to remove gaps
local function term_height(scale)
	local monitor  = hl.get_active_monitor()
	local overall = monitor.height * scale * monitor.scale
	return (overall - (overall % term_row_height))
end

-- Width of a terminal that factors in terminal col width to remove gaps (extra scaling down for wider monitors)
local function term_width(scale)
	local monitor  = hl.get_active_monitor()
	local overall = monitor.width * scale * monitor.scale * (monitor.height * 3) / (monitor.width * 2)
	return (overall - (overall % term_col_width))
end

-- local function split_thirds()
-- 	local mon  = hl.get_active_monitor()
-- 	local gaps_in  = hl.get_config('general.gaps_in')
-- 	local gaps_out = hl.get_config('general.gaps_out')
--
-- end

-- Events for creating subgroup notifications
local submap_timeout = 15000
hl.on( 'keybinds.submap', function(name)
	if name == 'capture' then
		hl.notification.create({
			text = 'a - Select Area\ns - Entire Screen\no - OCR\nr - Screen Record Gif',
			duration = submap_timeout,
			color = 'rgb(81c8be)',
		})
		hl.timer( function() hl.dispatch( hl.dsp.submap('reset') ) end, { timeout = submap_timeout, type = 'oneshot' } )
	elseif name == 'notify' then
		hl.notification.create({
			text = 'x - Dismiss\np - Pop Recent\nc - Context',
			duration = submap_timeout,
			color = 'rgb(81c8be)',
		})
		hl.timer( function() hl.dispatch( hl.dsp.submap('reset') ) end, { timeout = submap_timeout, type = 'oneshot' } )
	elseif name == 'shutdown' then
		hl.notification.create({
			text = 'l - Lock Screen\ns - Suspend\nx - Exit Hyprland',
			duration = submap_timeout,
			color = 'rgb(81c8be)',
		})
		hl.timer( function() hl.dispatch( hl.dsp.submap('reset') ) end, { timeout = submap_timeout, type = 'oneshot' } )
	elseif name == 'terminal' then
		hl.notification.create({
			text = 'Terminal Launcher\nb - Btop\nc - Calculator\nf - Floating Kitty\nq - Kitty\ny - Yazi File Manager',
			duration = submap_timeout,
			color = 'rgb(81c8be)',
		})
		hl.timer( function() hl.dispatch( hl.dsp.submap('reset') ) end, { timeout = submap_timeout, type = 'oneshot' } )
	elseif name == '' then
		hl.dispatch( e 'hyprctl dismissnotify' )
	end
end )

-- Terminal Launchers
b( m 'q', hl.dsp.submap('terminal') )
hl.define_submap( 'terminal', 'reset', function()
	b( 'b',        e('kitty btop', { opacity = '0.85', float  = true, size = {term_width(0.7), term_height(0.7)} }) )
	b( 'c',        e('kitty qalc', { opacity = '0.85', float  = true, size = {term_width(0.2), term_height(0.2)} }) )
	b( 'f',        e('kitty',      { opacity = '0.85', float  = true, size = {term_width(0.6), term_height(0.6)} }) )
	b( 'q',        e('kitty',      { opacity = '0.85', pseudo = true, size = {term_width(0.6), term_height(0.6)} }) )
	b( 'y',        e('kitty yazi', { opacity = '0.75', float   = true, size = {term_width(0.6), term_height(0.6)} }) )
	b( 'catchall', hl.dsp.submap('reset') )
end )

-- Other Launchers
b( m 'r', e 'fuzzel' )
b( m 'u', e 'hyprpicker -a' )
b( m 'm', e 'keepmenu' )

-- Screen Capture
b( m 'p', hl.dsp.submap('capture') )
hl.define_submap( 'capture', 'reset', function()
	b( 's',        e 'grim $(xdg-user-dir PICTURES)/Screenshots/$(date +"%Y%m%d%H%M%S.png")' )
	b( 'a',        e 'slurp | grim -g - - | magick - -shave 1x1 PNG:- | swappy -f -' )
	b( 'o',        e 'slurp | grim -g - - | tesseract - - | wl-copy' )
	b( 'r',        e '/nix/config/scripts/screenRecord.sh' )
	b( 'catchall', hl.dsp.submap('reset') )
end )

-- Play Media
b( m 'g', e '/nix/hhonfig/scripts/yt-dlp.sh' )

-- Notification Controls
b( m 'n', hl.dsp.submap('notify') )
hl.define_submap( 'notify', 'reset', function()
	b( 'x',        e 'dunstctl close' )
	b( 'p',        e 'dunstctl history-pop' )
	b( 'c',        e 'dunstctl context' )
	b( 'catchall', hl.dsp.submap('reset') )
end )

-- Use wtype to paste into things that do not like to obey paste keybinds
b( m 'v', e 'ewtype $(cliphist list | fuzzel -d | cliphist decode' )

-- Media controls
b( 'XF86AudioRaiseVolume',    e 'pamixer -i 1',                  { locked = true, repeating = true } )
b( 'XF86AudioLowerVolume',    e 'pamixer -d 1',                  { locked = true, repeating = true } )
b( 'XF86AudioMute',           e 'pamixer -t',                    { locked = true } )
b( s 'XF86AudioRaiseVolume',  e 'pamixer --default-source -i 1', { locked = true, repeating = true } )
b( s 'XF86AudioLowerVolume',  e 'pamixer --default-source -d 1', { locked = true, repeating = true } )
b( s 'XF86AudioMute',         e 'pamixer --default-source -t',   { locked = true } )
b( 'XF86AudioNext',           e 'playerctl next',                { locked = true } )
b( 'XF86AudioPlay',           e 'playerctl play-pause',          { locked = true } )
b( 'XF86AudioPause',          e 'playerctl play-pause',          { locked = true } )
b( 'XF86AudioPrev',           e 'playerctl previous',            { locked = true } )

-- Brightness
b( 'XF86MonBrightnessUp',   e 'brightnessctl set +5%', { locked = true, repeating = true } )
b( 'XF86MonBrightnessDown', e 'brightnessctl set 5%-', { locked = true, repeating = true } )

-- Hyprland Controls
b( m 'x',         hl.dsp.window.close() )
b( m 'w',         hl.dsp.window.float({ action = 'toggle' }) )
b( m 'o',         hl.dsp.window.pseudo() )
b( m 'f',         hl.dsp.window.fullscreen() )
-- b( m 'code:691',  align_workspace() )
b( m 'Tab', function()
	hl.dispatch( hl.dsp.window.cycle_next() )
	hl.dispatch( hl.dsp.window.bring_to_top() )
end )

-- Shutdown Menu
b( ms 'x', hl.dsp.submap('shutdown') )
hl.define_submap( 'shutdown', 'reset', function()
	b( 'l',        e 'hyprlock' )
	b( 's',        e 'systemctl suspend' )
	b( 'x',        e 'uwsm stop' )
	b( 'catchall', hl.dsp.submap('reset') )
end )

-- Focus Windows
b( m 'h', hl.dsp.focus({ direction = 'l' }) )
b( m 'j', hl.dsp.focus({ direction = 'd' }) )
b( m 'k', hl.dsp.focus({ direction = 'u' }) )
b( m 'l', hl.dsp.focus({ direction = 'r' }) )

-- Move Windows
b( ms 'h',        hl.dsp.window.move({ direction = 'l' }) )
b( ms 'j',        hl.dsp.window.move({ direction = 'd' }) )
b( ms 'k',        hl.dsp.window.move({ direction = 'u' }) )
b( ms 'l',        hl.dsp.window.move({ direction = 'r' }) )
b( m 'mouse:272', hl.dsp.window.drag(), { mouse = true } )

-- Resize Windows
b( m 'left',      hl.dsp.window.resize({ x = -24,  y = 0,  relative = true}), { repeating = true } ) -- width of one terminal col
b( m 'down',      hl.dsp.window.resize({ x = 0,   y = 19,  relative = true}), { repeating = true } ) -- height of one terminal row
b( m 'up',        hl.dsp.window.resize({ x = 0,   y = -19, relative = true}), { repeating = true } ) -- height of one terminal row
b( m 'right',     hl.dsp.window.resize({ x = 24,   y = 0,  relative = true}), { repeating = true } ) -- width of one terminal col
b( ms 'left',     hl.dsp.window.resize({ x = -1,  y = 0,   relative = true}), { repeating = true } )
b( ms 'down',     hl.dsp.window.resize({ x = 0,   y = 1,   relative = true}), { repeating = true } )
b( ms 'up',       hl.dsp.window.resize({ x = 0,   y = -1,  relative = true}), { repeating = true } )
b( ms 'right',    hl.dsp.window.resize({ x = 1,  y = 0,    relative = true}), { repeating = true } )
b( m 'mouse:273', hl.dsp.window.resize(), { mouse = true } )

-- Switch Workspace
b( m 'code:59',    hl.dsp.focus({ workspace = 'e-1' }) ) -- ,
b( m 'code:60',    hl.dsp.focus({ workspace = 'e+1' }) ) -- .
b( m 'mouse_down', hl.dsp.focus({ workspace = 'e-1' }) )
b( m 'mouse_up',   hl.dsp.focus({ workspace = 'e+1' }) )
for i = 1,10 do
	b( m(i % 10),   hl.dsp.focus({ workspace = i }) )
	b( ms(i % 10),  hl.dsp.window.move({ workspace = i, follow = false }) )
end

--<------------------
-- Workspace Rules -->
---------------------



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
	move        = '{0, 26}',
	no_blur     = false,
	no_shadow   = false,
	opaque      = true,
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
	stay_focused     = false,
	suppress_event   = 'fullscreen maximize',
})

wr({ name = 'helium', match = { class = 'helium' }, opacity = '0.85' })
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

wr({ name = 'telegram', match = { class = '.*telegram.*' }, opacity = '0.85' })

--<------------------

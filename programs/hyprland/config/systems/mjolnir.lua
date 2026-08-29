hl.on( 'hyprland.start', function()
	hl.exec_cmd 'wayland-push-to-talk-fix -k "BTN_MIDDLE" -n "XF86WheelButton" /dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse'
end )

hl.monitor({
	output   = 'desc:BOE 0x095F',
	mode     = '2256x1504@60',
	position = 'auto',
	-- scale    = '1.0',                -- 2256x1504
	-- scale    = '1.1749999523162842', -- 1920x1280
	scale    = '1.3333333730697632', -- 1692x1128
	-- scale    = '1.5666667222976685', -- 1437x958
	-- scale    = '1.6000000238418579', -- 1410x940
	-- scale    = '1.9583333730697632', -- 1151x767
	-- scale    = '2.0',                -- 1128x752
	vrr      = 0,
})

hl.monitor({
	output              = 'desc:LG Electronics LG HDR WQHD 304NTPCBM192',
	mode                = '3440x1440@85',
	position            = 'auto',
	scale               = '1.0',
	bitdepth            = 10,
	sdrbrightness       = 1.2,
	sdrsaturation       = 0.98,
	supports_hdr        = 1,
	supports_wide_color = 1,
	vrr                 = 1,
})

local ultrawide_attached = false
for _, mon in pairs( hl.get_monitors() ) do
	if mon.size.width == 3440 then ultrawide_attached = true end
end

if ultrawide_attached then
	hl.monitor({ output = 'desc:BOE 0x095F', disabled = true })
	hl.config({ general = {
		gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
		gaps_out = { top = 1, left = 18, right = 18, bottom = 18 }, -- 20
	} })
else
	hl.monitor({ output = 'desc:BOE 0x095F', disabled = false })
	hl.config({ general = {
		gaps_in  = { top = 8, left = 14, right = 14, bottom = 9 }, -- 5
		gaps_out = { top = 1, left = 20, right = 20, bottom = 24 }, -- 20
	} })
end

-- Shorthand
local b, e = hl.bind, hl.dsp.exec_cmd
local m, s, c, a = 'SUPER + ', 'SHIFT + ', 'CTRL + ', 'ALT + '

-- Size functions
local function win_large_size()
	local mon = hl.get_active_monitor() or ''

	local w, h = 1394, 1031 -- Default
	if mon.width == 3440 then
		w, h = 1080, 855
	end

	return { w, h }
end

b( m..s..'c', e('kitty --session ~/.config/kitty/sessions/nixos.kitty-session', { float = true, size = win_large_size() }) )
b( m..'o',    e('kitty --session ~/.config/kitty/sessions/notes.kitty-session', { float = true, size = win_large_size() }) )
b( m..'y',    e('kitty --session ~/.config/kitty/sessions/yazi.kitty-session',  { float = true, size = win_large_size() }) )

-- Play Media
b( m..'g', e '/nix/config/scripts/yt-dlp.sh' )


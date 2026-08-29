hl.on( 'hyprland.start', function()
	hl.exec_cmd 'wayland-push-to-talk-fix -k "grave" -n "grave" /dev/input/by-id/usb-04d9_daskeyboard-event-kbd'
end )

hl.monitor({
	output   = 'desc:LG Electronics MP59G 708NTGYGY135',
	mode     = '1920x1080@75',
	position = 'auto',
	scale    = '1.0',
	vrr      = 1,
})

hl.config({ general = {
	gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
	gaps_out = { top = 1, left = 18, right = 18, bottom = 18 }, -- 20
} })

local b, e = hl.bind, hl.dsp.exec_cmd

-- Push to talk at the system level
b( 'grave', function()
	if hl.get_active_window().class ~= 'kitty' then
		hl.dispatch( e('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0') )
	else
		hl.dispatch( hl.dsp.send_shortcut({ mods = '', key = 'grave' }) )
	end
end )
b( 'grave', function()
	if hl.get_active_window().class ~= 'kitty' then
		hl.dispatch( e('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1') )
	end
end, { release = true } )


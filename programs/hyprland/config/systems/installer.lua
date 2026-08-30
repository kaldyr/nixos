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


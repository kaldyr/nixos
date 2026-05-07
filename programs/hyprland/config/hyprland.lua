-- Config   --
-- Startup       -->
-------------------
-- vim:fdm=marker:fdl=0:foldmarker=-->,<--

-- Get the hostname for machine specific configs
local hostname = ''
local f = io.popen ('hostname')
if f ~= nil then
	hostname = f:read('*a') or ''
	f:close()
end
hostname = string.gsub(hostname, '\n$', '')

-- Startup applications
local exe = hl.exec.cmd
hl.on( 'hyprland.start', function()

	exe( 'systemctl --user start wallpaper-change.timer' )
	exe( 'wl-paste --type text --watch cliphist store' )
	exe( 'wl-paste --type image --watch cliphist store' )
	exe( 'waybar' )
	exe( 'nm-applet' )
	exe( 'tailscale systray' )

	if hostname == 'espresso' then
		exe( "wayland-push-to-talk-fix -k 'grave' -n 'grave' /dev/input/by-id/usb-04d9_daskeyboard-event-kbd" )
	elseif hostname == 'hofud' then
		exe( 'pamixer -m' )
	elseif hostname == 'mjolnir' then
		exe( "wayland-push-to-talk-fix -k 'BTN_MIDDLE' -n 'XF86WheelButton' /dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse" )
		exe( 'nmcli radio wifi off' )
		exe( 'pamixer --default-source -m' )
	end

end )

--<----------------
-- Monitors      -->
-------------------

-- Main monitor
local output, mode, position, scale = '', 'preferred', 'auto', 'auto'
if hostname == 'espresso' then
	output = 'HDMI-A-1'
	mode   = '1920x1080@60'
elseif hostname == 'hofud' then
	output = 'eDP-1'
	mode   = '2256x1504@60'
	position = '0x0'
	scale = '1.175000'
elseif hostname == 'mjolnir' then
	output = 'HDMI-A-1'
	mode   = '3440x1440@84.97900'
end
hl.monitor( output, mode, position, scale )

--<----------------
-- Environment   -->
-------------------

hl.env( 'HYPRCURSOR_THEME', 'catppuccin-frappe-sapphire-cursors' )
hl.env( 'HYPRCURSOR_SIZE', '24' )
hl.env( 'NIXOS_OZONE_WL', '"1"' )
hl.env( 'PROTON_ENABLE_WAYLAND', '"1"' )
hl.env( 'WLR_NO_HARDWARE_CURSORS', '"1"' )

--<----------------
-- Look and Feel -->
-------------------
--<----------------
-- Miscelanous   -->
-------------------
--<----------------
-- Input         -->
-------------------
--<----------------
-- Keybindings   -->
-------------------
--<----------------
-- Window Rules  -->
-------------------
--<----------------

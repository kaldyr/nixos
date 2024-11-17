{ sysConfig, ... }: {

    hardware.openrazer.enable = true;
    hardware.openrazer.devicesOffOnScreensaver = true;

    home-manager.users.${sysConfig.user}.xdg.configFile."openrazer/persistence.conf".text = /* ini */ ''
        [632423H20104252]
        dpi_x = 800
        dpi_y = 800
        poll_rate = 1000
        backlight_active = True
        backlight_brightness = 100
        backlight_colors = 255 255 255 255 255 255 255 255 255
        backlight_effect = wave
        backlight_speed = 1
        backlight_wave_dir = 2
        logo_active = True
        logo_brightness = 100
        logo_colors = 255 255 255 255 255 255 255 255 255
        logo_effect = wave
        logo_speed = 1
        logo_wave_dir = 2
        scroll_active = True
        scroll_brightness = 100
        scroll_colors = 255 255 255 255 255 255 255 255 255
        scroll_effect = wave
        scroll_speed = 1
        scroll_wave_dir = 2
    '';

    users.users.${sysConfig.user}.extraGroups = [ "openrazer" ];

}

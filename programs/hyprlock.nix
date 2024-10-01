{ pkgs, sysConfig, ... }: {


    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ hyprlock ];

        xdg.configFile."hypr/hyprlock.conf".text = /* hyprlang */ ''
            source=~/.config/hypr/frappe.conf

            $accent = 0xb3$sapphireAlpha
            $accentAlpha = $sapphireAlpha
            $font = Recursive Mn Csl St

            # GENERAL
            general {
                disable_loading_bar = true
                hide_cursor = true
            }

            # BACKGROUND
            background {
                monitor =
                path = $HOME/Pictures/Wallpapers/mountain.jpg
                blur_passes = 2
                color = $base
            }

            # TIME
            label {
                monitor =
                text = cmd[update:1000] echo "<b>$(date +"%l:%M %p")</b>"
                color = $text
                font_size = 60
                font_family = $font
                position = -130, -100
                halign = right
                valign = top
                shadow_passes = 2
            }

            # DATE
            label {
                monitor =
                text = cmd[update:1000] echo "$(date +"%A, %B %e %Y")"
                color = $text
                font_size = 20
                font_family = $font
                position = -130, -250
                halign = right
                valign = top
                shadow_passes = 2
            }

            # USER AVATAR
            image {
                monitor =
                path = $HOME/Pictures/Saved/profile.png
                size = 350
                border_color = $accent
                rounding = -1
                position = 0, 75
                halign = center
                valign = center
                shadow_passes = 2
            }

            # INPUT FIELD
            input-field {
                monitor =
                size = 500, 60
                outline_thickness = 4
                dots_size = 0.2
                dots_spacing = 0.2
                dots_center = true
                outer_color = $accent
                inner_color = $surface0
                font_color = $text
                fade_on_empty = false
                placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
                hide_input = false
                check_color = $sky
                fail_color = $red
                fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
                capslock_color = $yellow
                position = 0, -185
                halign = center
                valign = center
                shadow_passes = 2
            }
        '';

    };

}

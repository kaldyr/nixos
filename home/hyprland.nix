{ pkgs, ... }: {

    imports = [
        ./desktop.nix
        ./programs/dunst.nix
        ./programs/feh.nix
        ./programs/fuzzel.nix
        ./programs/gammastep.nix
        ./programs/swappy.nix
        ./programs/udiskie.nix
        ./programs/waybar.nix
        ./programs/wezterm
    ];

    home.packages = with pkgs; [
        brightnessctl
        cliphist
        dconf
        grim
        hyprpicker
        libnotify
        pamixer
        pavucontrol
        polkit_gnome
        slurp
        swww
        tesseract
        wl-clipboard
        xdg-desktop-portal-hyprland
    ];

    services.cliphist.enable = true;
    services.playerctld.enable = true;

    wayland.windowManager.hyprland = {

        enable = true;

        settings = {
            "$mainMod" = "SUPER";
            "$terminal" = "wezterm";

            source = [ "~/.config/hypr/frappe.conf" ];

            animations = {
                enabled = "yes";
                animation = [
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "workspaces, 1, 6, default"
                ];
                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            };

            bind = [
                # Main
                "$mainMod, q, exec, $terminal"
                "$mainMod, c, killactive,"
                "$mainMod, m, exit,"
                "$mainMod, v, togglefloating,"
                "$mainMod, r, exec, fuzzel"
                "$mainMod, o, pseudo,"
                "$mainMod, s, togglesplit,"
                "$mainMod, f, fullscreen,"
                # Screenshots
                "$mainMod, p, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y%m%d%H%M%S.png')"
                "$mainMod SHIFT, p, exec, grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | swappy -f - "
                "$mainMod ALT, p, exec, grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | tesseract - - | wl-copy --primary"
                # Set wallpaper
                "$mainMod, y, exec, ln -sf $(command ls $HOME/Pictures/Wallpapers | fuzzel --dmenu) $HOME/Pictures/Wallpapers/.wallpaper && swww img $HOME/Pictures/Wallpapers/.wallpaper"
                "$mainMod, u, exec, hyprpicker -a"
                # Play url from clipboard in mpv
                "$mainMod, g, exec, mpv $(wl-paste)"
                # Monitor flipping for laptop in tent mode
                "$mainMod, t, exec, hyprctl keyword monitor eDP-1,preferred,auto,1,transform,2"
                "$mainMod SHIFT, t, exec, hyprctl keyword monitor eDP-1,preferred,auto,1,transform,0"
                # Notifications
                "$mainMod, n, exec, dunstctl history-pop"
                "$mainMod SHIFT, n, exec, dunstctl context"
                "$mainMod ALT, n, exec, dunstctl close"
                # Media Controls
                ", $XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 1"
                ", $XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 1"
                ", $XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
                "SHIFT, $$XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --default-source -i 1"
                "SHIFT, $$XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --default-source -d 1"
                "SHIFT, $$XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t"
                ", $XF86AudioPlay, exec, playerctl play-pause"
                ", $XF86AudioNext, exec, playerctl next"
                ", $XF86AudioPrev, exec, playerctl prev"
                # Discord PTT
                # "$mainMod, mouse:274,pass,^(discord)$"
                "ALT, mouse:274, pass, ^(discord)$"
                # Brightness
                ", $XF86MonBrightnessUp, exec, brightnessctl set +5%"
                ", $XF86MonBrightnessDown, exec, brightnessctl set -5%"
                # Move focus with mainMod + arrow keys
                "$mainMod, h, movefocus, l"
                "$mainMod, l, movefocus, r"
                "$mainMod, k, movefocus, u"
                "$mainMod, j, movefocus, d"
                # Move active window with mainMod + SHIFT + [H, J, K, L]
                "$mainMod SHIFT, H, movewindow, l"
                "$mainMod SHIFT, J, movewindow, d"
                "$mainMod SHIFT, K, movewindow, u"
                "$mainMod SHIFT, L, movewindow, r"
                # Resize active window with mainMod + ALT + [H, J, K, L]
                "$mainMod ALT, H, resizeactive, -1 0"
                "$mainMod ALT, J, resizeactive, 0 1"
                "$mainMod ALT, K, resizeactive, 0 -1"
                "$mainMod ALT, L, resizeactive, 1 0"
                # Switch workspaces with mainMod + [0-9]
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"
                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
                "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
                "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
                "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
                "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
                "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
                "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
                "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
                "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
                "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"
            ];

            bindm = [
                # Move/resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ];

            decoration = {

                blur = {
                    enabled = true;
                    contrast = 1.0;
                    ignore_opacity = true;
                    new_optimizations = true;
                    noise = 0.03;
                    passes = 3;
                    size = 12;
                    xray = true;
                };

                "col.shadow" = "rgba(1a1a1aee)";
                dim_inactive = false;
                drop_shadow = "yes";
                rounding = 10;
                shadow_range = 20;
                shadow_render_power = 3;

            };

            dwindle = {
                preserve_split = "yes";
                pseudotile = "yes";
            };

            exec-once = [
                "swww-daemon --format xrgb"
                "swww img $HOME/Pictures/Wallpapers/.wallpaper"
                "wl-paste --type text --watch cliphist store"
                "wl-paste --type image --watch cliphist store"
                "waybar"
            ];

            general = {
                border_size = 0;
                gaps_in = 14;
                gaps_out = 28;
                layout = "dwindle";
            };

            gestures.workspace_swipe = true;

            input = {
                kb_layout = "us";
                sensitivity = 0;
                touchpad.natural_scroll = "no";
            };

            layerrule = [ "blur, launcher" ];

            misc = {
                disable_hyprland_logo = "yes";
                animate_mouse_windowdragging = "yes";
                vrr = 1;
            };

            monitor = [
                ", preferred, 0x0, 1"
            ];

            windowrulev2 = [
                "opacity 0.90 override 0.90 override, class:($terminal)$"
                "opacity 0.90 override 0.90 override, class:(neovide)$"
                "opacity 0.90 override 0.90 override, class:librewolf"
                "opacity 0.90 override 0.90 override, class:org.telegram.desktop"
                "opacity 0.90 override 0.90 override, class:discord"
                "opacity 0.90 override 0.90 override, class:steam$"
                "noshadow, class:steam_app_"
                "noblur, class:steam_app_"
                "noborder, class:steam_app_"
                "pseudo, class:($terminal)$"
                "pseudo, class:(mpv)"
                "pseudo, class:(feh)"
            ];

        };

        xwayland.enable = true;

    };

    xdg = {

        configFile."hypr/frappe.conf".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "hyprland";
            rev = "99a88fd21fac270bd999d4a26cf0f4a4222c58be";
            sha256 = "sha256-07B5QmQmsUKYf38oWU3+2C6KO4JvinuTwmW1Pfk8CT8=";
        } + "/themes/frappe.conf";

        mimeApps.defaultApplications = {
            "default-web-browser" = [ "librewolf.desktop" ];
            "text/html" = [ "librewolf.desktop" ];
            "x-scheme-handler/ftp" = [ "librewolf.desktop" ];
            "x-scheme-handler/http" = [ "librewolf.desktop" ];
            "x-scheme-handler/https" = [ "librewolf.desktop" ];
            "application/md" = [ "librewolf.desktop" ];
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];
            "application/image" = [ "feh.desktop" ];
            "application/video" = [ "mpv.desktop" ];
            "application/audio" = [ "mpv.desktop" ];
        };

    };

}

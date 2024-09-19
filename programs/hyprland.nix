{ pkgs, sysConfig, ... }: {

    imports = [
        ./dunst.nix
        ./feh.nix
        ./fuzzel.nix
        ./gammastep.nix
        ./swappy.nix
        ./udiskie.nix
        ./waybar.nix
        ./foot.nix
    ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            brightnessctl
            cliphist
            dconf
            grim
            hyprpicker
            libnotify
            pamixer
            pavucontrol
            playerctl
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

            extraConfig = let 

                monitorConf = (
                    if sysConfig.hostname == "gram" then /* hyprlang */
                        "monitor=eDP-1, 2256x1504@60, 0x0, 1"
                    else if sysConfig.hostname == "mjolnir" then /* hyprlang */
                        "monitor=HDMI-A-1, 3440x1440@84.97900, 0x0, 1"
                    else "" );

            in /* hyprlang */ ''
                $mainMod=SUPER

                source=~/.config/hypr/frappe.conf

                animations {
                    bezier=myBezier, 0.05, 0.9, 0.1, 1.05
                    animation=border, 1, 10, default
                    animation=borderangle, 1, 8, default
                    animation=fade, 1, 7, default
                    animation=windows, 1, 7, myBezier
                    animation=windowsOut, 1, 7, default, popin 80%
                    animation=workspaces, 1, 6, default
                    enabled=yes
                }

                decoration {
                    blur {
                        contrast=1.000000
                        enabled=true
                        ignore_opacity=true
                        new_optimizations=true
                        noise=0.030000
                        passes=3
                        size=12
                        xray=true
                    }
                    col.shadow=rgba(1a1a1aee)
                    dim_inactive=false
                    drop_shadow=yes
                    rounding=10
                    shadow_range=20
                    shadow_render_power=3
                }

                dwindle {
                    preserve_split=yes
                    pseudotile=yes
                }

                general {
                    border_size=0
                    gaps_in=14
                    gaps_out=28
                    layout=dwindle
                }

                gestures {
                    workspace_swipe=true
                }

                input {
                    touchpad {
                        natural_scroll=no
                    }
                    kb_layout=us
                    sensitivity=0
                }

                misc {
                    animate_mouse_windowdragging=yes
                    disable_hyprland_logo=yes
                    vrr=1
                }

                # Launch Applications
                bind=$mainMod, q, exec, foot
                bind=$mainMod, r, exec, fuzzel
                bind=$mainMod, u, exec, hyprpicker -a

                # Screenshots
                bind=$mainMod, p, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y%m%d%H%M%S.png')
                bind=$mainMod SHIFT, p, exec, grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | swappy -f - 
                bind=$mainMod ALT, p, exec, grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | tesseract - - | wl-copy --primary

                # Wallpaper
                bind=$mainMod, y, exec, ln -sf $(command ls $HOME/Pictures/Wallpapers | fuzzel --dmenu) $HOME/Pictures/Wallpapers/.wallpaper && swww img $HOME/Pictures/Wallpapers/.wallpaper

                # Play media from clipboard
                bind=$mainMod, g, exec, mpv $(wl-paste)

                # Notification Controls
                bind=$mainMod, n, exec, dunstctl history-pop
                bind=$mainMod SHIFT, n, exec, dunstctl context
                bind=$mainMod ALT, n, exec, dunstctl close

                # Media controls
                bind=, XF86AudioRaiseVolume, exec, pamixer -i 1
                bind=, XF86AudioLowerVolume, exec, pamixer -d 1
                bind=, XF86AudioMute, exec, pamixer -t
                bind=SHIFT, XF86AudioRaiseVolume, exec, pamixer --default-source -i 1
                bind=SHIFT, XF86AudioLowerVolume, exec, pamixer --default-source -d 1
                bind=SHIFT, XF86AudioMute, exec, pamixer --default-source -t
                bind=, XF86AudioPlay, exec, playerctl play-pause
                bind=, XF86AudioNext, exec, playerctl next
                bind=, XF86AudioPrev, exec, playerctl prev

                # Brightness
                bind=, XF86MonBrightnessUp, exec, brightnessctl set +5%
                bind=, XF86MonBrightnessDown, exec, brightnessctl set 5%-

                # Hyprland controls
                bind=$mainMod, c, killactive,
                bind=$mainMod, m, exit,
                bind=$mainMod, v, togglefloating,
                bind=$mainMod, o, pseudo,
                bind=$mainMod, s, togglesplit,
                bind=$mainMod, f, fullscreen,

                # Focus
                bind=$mainMod, h, movefocus, l
                bind=$mainMod, l, movefocus, r
                bind=$mainMod, k, movefocus, u
                bind=$mainMod, j, movefocus, d

                # Move Windows
                bind=$mainMod SHIFT, H, movewindow, l
                bind=$mainMod SHIFT, J, movewindow, d
                bind=$mainMod SHIFT, K, movewindow, u
                bind=$mainMod SHIFT, L, movewindow, r

                # Resze Windows
                bind=$mainMod ALT, H, resizeactive, -1 0
                bind=$mainMod ALT, J, resizeactive, 0 1
                bind=$mainMod ALT, K, resizeactive, 0 -1
                bind=$mainMod ALT, L, resizeactive, 1 0
                bind=$mainMod CTRL, H, resizeactive, -100 0
                bind=$mainMod CTRL, J, resizeactive, 0 100
                bind=$mainMod CTRL, K, resizeactive, 0 -100
                bind=$mainMod CTRL, L, resizeactive, 100 0

                # Switch Workspace
                bind=$mainMod, 1, workspace, 1
                bind=$mainMod, 2, workspace, 2
                bind=$mainMod, 3, workspace, 3
                bind=$mainMod, 4, workspace, 4
                bind=$mainMod, 5, workspace, 5
                bind=$mainMod, 6, workspace, 6
                bind=$mainMod, 7, workspace, 7
                bind=$mainMod, 8, workspace, 8
                bind=$mainMod, 9, workspace, 9
                bind=$mainMod, 0, workspace, 10

                # Move window to workspace
                bind=$mainMod SHIFT, 1, movetoworkspacesilent, 1
                bind=$mainMod SHIFT, 2, movetoworkspacesilent, 2
                bind=$mainMod SHIFT, 3, movetoworkspacesilent, 3
                bind=$mainMod SHIFT, 4, movetoworkspacesilent, 4
                bind=$mainMod SHIFT, 5, movetoworkspacesilent, 5
                bind=$mainMod SHIFT, 6, movetoworkspacesilent, 6
                bind=$mainMod SHIFT, 7, movetoworkspacesilent, 7
                bind=$mainMod SHIFT, 8, movetoworkspacesilent, 8
                bind=$mainMod SHIFT, 9, movetoworkspacesilent, 9
                bind=$mainMod SHIFT, 0, movetoworkspacesilent, 10

                # Mouse controls
                bind=$mainMod, mouse_down, workspace, e+1
                bind=$mainMod, mouse_up, workspace, e-1
                bindm=$mainMod, mouse:272, movewindow
                bindm=$mainMod, mouse:273, resizewindow

                # Auto-start Applications
                exec-once=gnome-keyring-daemon --start
                exec-once=swww-daemon --format xrgb
                exec-once=swww img $HOME/Pictures/Wallpapers/.wallpaper
                exec-once=wl-paste --type text --watch cliphist store
                exec-once=wl-paste --type image --watch cliphist store
                exec-once=pamixer --default-source -t
                exec-once=waybar

                # Layer Rules
                layerrule=blur, launcher

                # Monitors
                ${monitorConf}
                monitor=, preferred, auto, 1

                # Window Rules
                windowrulev2=opacity 0.90 override 0.90 override, class:foot
                windowrulev2=opacity 0.90 override 0.90 override, class:(neovide)$
                windowrulev2=opacity 0.90 override 0.90 override, class:librewolf
                windowrulev2=opacity 0.90 override 0.90 override, class:org.telegram.desktop
                windowrulev2=opacity 0.90 override 0.90 override, class:discord
                windowrulev2=opacity 0.90 override 0.90 override, class:steam$
                windowrulev2=noshadow, class:steam_app_
                windowrulev2=noblur, class:steam_app_
                windowrulev2=noborder, class:steam_app_
            '';

            xwayland.enable = true;

        };

        xdg.configFile."hypr/frappe.conf".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "hyprland";
            rev = "c388ac55563ddeea0afe9df79d4bfff0096b146b";
            sha256 = "sha256-xSa/z0Pu+ioZ0gFH9qSo9P94NPkEMovstm1avJ7rvzM=";
        } + "/themes/frappe.conf";

        xdg.mimeApps.defaultApplications = {
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

    services.greetd = {

        enable = true;

        settings = rec {
            default_session = initial_session;
            initial_session.command = "${pkgs.hyprland}/bin/Hyprland 1>/dev/null";
            initial_session.user = sysConfig.user;
        };

    };

}

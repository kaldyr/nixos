{ pkgs, sysConfig, ... }: {

    imports = [
        ../services/dunst.nix
        ../services/gammastep.nix
        ../services/hypridle.nix
        ../services/swww.nix
        ../services/udiskie.nix
        ./feh.nix
        ./foot.nix
        ./fuzzel.nix
        ./hyprlock.nix
        ./swappy.nix
        ./waybar.nix
    ];

    environment.sessionVariables = {
        HYPRCURSOR_THEME = "catppuccin-frappe-sapphire-cursors";
        HYPRCURSOR_SIZE = 24;
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
    };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            brightnessctl
            cliphist
            grim
            hyprcursor
            hyprpicker
            libnotify
            pavucontrol
            playerctl
            polkit_gnome
            slurp
            tesseract
            wl-clipboard
            wl-screenrec
            wtype
        ];

        services.cliphist.enable = true;
        services.playerctld.enable = true;

        wayland.windowManager.hyprland = {

            enable = true;

            extraConfig = let

                freesync = (
                    if sysConfig.hostname == "mjolnir" then "1"
                    else "0"
                );

                monitorConf = (
                    if sysConfig.hostname == "gram" then /* hyprlang */
                        "monitor=eDP-1, 2256x1504@60, 0x0, 1.175000"
                    else if sysConfig.hostname == "mjolnir" then /* hyprlang */
                        "monitor=HDMI-A-1, 3440x1440@84.97900, 0x0, 1"
                    else "" );

                pttFix = (
                    if sysConfig.hostname == "mjolnir" then /* hyprlang */
                        "exec-once=wayland-push-to-talk-fix -k 'BTN_MIDDLE' -n 'XF86WheelButton' /dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse"
                    else "" );

                screenRecord = pkgs.writeShellScriptBin "screenRecord.sh" /* bash */ ''
                    pid=`${pkgs.procps}/bin/pgrep wl-screenrec`
                    status=$?

                    if [ $status != 0 ]
                    then
                        ${pkgs.wl-screenrec}/bin/wl-screenrec -g "$(${pkgs.slurp}/bin/slurp)" --audio --low-power=off -f $HOME/Videos/Screenrec/$(date +'%Y%m%d%H%M%S.mp4');
                    else
                        ${pkgs.procps}/bin/pkill --signal SIGINT wl-screenrec
                    fi;
                '';

                terminal = (
                    if sysConfig.hostname == "oolong" then "foot"
                    else "wezterm" );

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
                    dim_inactive=false
                    rounding=10
                    shadow {
                        color=rgba(1a1a1aee)
                        enabled=yes
                        range=20
                        render_power=3
                    }
                }

                dwindle {
                    preserve_split=yes
                    pseudotile=yes
                }

                general {
                    border_size=1
                    col.active_border=$teal
                    gaps_in=8
                    gaps_out=12
                    layout=dwindle
                }

                gestures {
                    workspace_swipe=true
                }

                input {
                    follow_mouse=2
                    kb_layout=us
                    sensitivity=0
                    touchpad {
                        natural_scroll=no
                    }
                }

                misc {
                    animate_mouse_windowdragging=yes
                    disable_hyprland_logo=yes
                    vrr=${freesync}
                }

                # Launch Applications
                bind=$mainMod, q, exec, ${terminal}
                bind=$mainMod, r, exec, fuzzel
                bind=$mainMod, u, exec, hyprpicker -a

                # Screen Capture
                bind=$mainMod, p, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%Y%m%d%H%M%S.png')
                bind=$mainMod SHIFT, p, exec, slurp | grim -g - - | magick - -shave 1x1 PNG:- | swappy -f -
                bind=$mainMod ALT, p, exec, slurp | grim -g - - | tesseract - - | wl-copy
                bind=$mainMod SHIFT, r, exec, ${screenRecord}/bin/screenRecord.sh

                # Play media from clipboard
                bind=$mainMod, g, exec, mpv $(cliphist list | grep "://" | fuzzel -d | cliphist decode)

                # Notification Controls
                bind=$mainMod, n, exec, dunstctl history-pop
                bind=$mainMod SHIFT, n, exec, dunstctl context
                bind=$mainMod ALT, n, exec, dunstctl close

                # Use wtype to paste into things that do not like to obey paste keybinds
                bind=$mainMod, v, exec, wtype $(cliphist list | fuzzel -d | cliphist decode )

                # Media controls
                bind=, XF86AudioRaiseVolume, exec, pamixer -i 1
                bind=, XF86AudioLowerVolume, exec, pamixer -d 1
                bind=, XF86AudioMute, exec, pamixer -t
                bind=CTRL, XF86AudioRaiseVolume, exec, pamixer -i 5
                bind=CTRL, XF86AudioLowerVolume, exec, pamixer -d 5
                bind=SHIFT, XF86AudioRaiseVolume, exec, pamixer --default-source -i 1
                bind=SHIFT, XF86AudioLowerVolume, exec, pamixer --default-source -d 1
                bind=SHIFT, XF86AudioMute, exec, pamixer --default-source -t
                bind=CTRL SHIFT, XF86AudioRaiseVolume, exec, pamixer --default-source -i 5
                bind=CTRL SHIFT, XF86AudioLowerVolume, exec, pamixer --default-source -d 5
                bind=, XF86AudioPlay, exec, playerctl play-pause
                bind=, XF86AudioNext, exec, playerctl next
                bind=, XF86AudioPrev, exec, playerctl previous

                # Brightness
                bind=, XF86MonBrightnessUp, exec, brightnessctl set +5%
                bind=, XF86MonBrightnessDown, exec, brightnessctl set 5%-

                # Hyprland controls
                bind=$mainMod, x, killactive,
                bind=$mainMod SHIFT, x, exit,
                bind=$mainMod, w, togglefloating,
                bind=$mainMod, o, pseudo,
                bind=$mainMod, s, togglesplit,
                bind=$mainMod, f, fullscreen,
                bind=$mainMod SHIFT, s, exec, hyprlock
                bind=$mainMod ALT, s, exec, systemctl suspend

                # Focus
                bind=$mainMod, h, movefocus, l
                bind=$mainMod, l, movefocus, r
                bind=$mainMod, k, movefocus, u
                bind=$mainMod, j, movefocus, d

                # Move Windows
                bind=$mainMod SHIFT, h, movewindow, l
                bind=$mainMod SHIFT, j, movewindow, d
                bind=$mainMod SHIFT, k, movewindow, u
                bind=$mainMod SHIFT, l, movewindow, r

                # Resze Windows
                bind=$mainMod ALT, h, resizeactive, -1 0
                bind=$mainMod ALT, j, resizeactive, 0 1
                bind=$mainMod ALT, k, resizeactive, 0 -1
                bind=$mainMod ALT, l, resizeactive, 1 0
                bind=$mainMod CTRL, h, resizeactive, -559 0 # Move window width from 1/2 screen to 1/3 screen
                bind=$mainMod CTRL, j, resizeactive, 0 222 # Move window height from 1/2 screen to 1/3 screen
                bind=$mainMod CTRL, k, resizeactive, 0 -222 # Move window width from 1/2 screen to 1/3 screen
                bind=$mainMod CTRL, l, resizeactive, 559 0 # Move window height from 1/2 screen to 1/3 screen

                # Switch Workspace
                bind=$mainMod, code:59, workspace, -1 # ,
                bind=$mainMod, code:60, workspace, +1 # .
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
                exec-once=wl-paste --type text --watch cliphist store
                exec-once=wl-paste --type image --watch cliphist store
                exec-once=waybar
                ${pttFix}

                # Layer Rules
                layerrule=blur, launcher

                # Monitors
                ${monitorConf}
                monitor=, preferred, auto, 1

                # Window Rules
                windowrulev2=opacity 0.90 override 0.90 override, class:foot
                windowrulev2=opacity 0.90 override 0.90 override, class:org.wezfurlong.wezterm
                windowrulev2=opacity 0.90 override 0.90 override, class:com.mitchellh.ghostty
                windowrulev2=opacity 0.90 override 0.90 override, class:librewolf
                windowrulev2=opacity 0.90 override 0.90 override, class:org.telegram.desktop
                windowrulev2=opacity 0.90 override 0.90 override, class:discord
                windowrulev2=opacity 0.90 override 0.90 override, class:steam$
                windowrulev2=noshadow, class:steam_app_
                windowrulev2=noblur, class:steam_app_
                windowrulev2=noborder, class:steam_app_

                # gw2
                windowrulev2=bordersize 0,title:^(Guild Wars 2)$
                windowrulev2=opaque,title:^(Guild Wars 2)$
                windowrulev2=noblur,title:^(Guild Wars 2)$
                windowrulev2=noshadow,title:^(Guild Wars 2)$
                windowrulev2=norounding,title:^(Guild Wars 2)$

                # blish hud
                windowrulev2=noblur,title:^(Blish HUD)$
                windowrulev2=float, title:^(Blish HUD)$
                windowrulev2=center, title:^(Blish HUD)$
                windowrulev2=nofocus, title:^(Blish HUD)$
                windowrulev2=noinitialfocus, title:^(Blish HUD)$
                windowrulev2=noborder, title:^(Blish HUD)$
                windowrulev2=pin, title:^(Blish HUD)$
                windowrulev2=opacity 0.5 0.1, title:^(Blish HUD)$
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

    xdg.portal = {

        enable = true;

        config.common.default = "*";

        configPackages = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal
        ];

        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            xdg-desktop-portal
        ];

        wlr.enable = true;

    };

}

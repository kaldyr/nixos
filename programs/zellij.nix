{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [ ".cache/zellij" ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ zellijPlugins.zjstatus ];

        programs.fish.shellAliases."dev" = let

            buildDevLayout = pkgs.writeShellScript "buildDevLayout.sh" /* bash */ ''
                zellij --layout dev
                sleep 0.2
                zellij action move-focus down
                zellij action write-chars "+"
                zellij action move-focus up
                zellij action write-chars "+"
                zellij action move-focus right
            '';

        in "${pkgs.bash}/bin/bash ${buildDevLayout}";

        programs.zellij.enable = true;
        programs.zellij.enableFishIntegration = true;

        xdg.configFile."zellij/config.kdl".text = /* kdl */ ''
            copy_clipboard "primary"
            copy_command "wl-copy"
            copy_on_select true

            keybinds clear-defaults=true {
                locked {
                    bind "Alt g" { SwitchToMode "Normal"; }
                }
                pane {
                    bind "Alt p" "Esc" "Enter" { SwitchToMode "Normal"; }
                    bind "h" { MovePane "Left"; }
                    bind "j" { MovePane "Down"; }
                    bind "k" { MovePane "Up"; }
                    bind "l" { MovePane "Right"; }
                    bind "s" { NewPane "Right"; SwitchToMode "Normal"; }
                    bind "v" { NewPane "Down"; SwitchToMode "Normal"; }
                    bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; }
                    bind "x" { CloseFocus; SwitchToMode "Normal"; }
                    bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
                    bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
                }
                renamepane {
                    bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
                    bind "Enter" { SwitchToMode "Normal"; }
                }
                resize {
                    bind "Alt r" "Esc" "Enter" { SwitchToMode "Normal"; }
                    bind "h" { Resize "Increase Left"; }
                    bind "j" { Resize "Increase Down"; }
                    bind "k" { Resize "Increase Up"; }
                    bind "l" { Resize "Increase Right"; }
                    bind "H" { Resize "Decrease Left"; }
                    bind "J" { Resize "Decrease Down"; }
                    bind "K" { Resize "Decrease Up"; }
                    bind "L" { Resize "Decrease Right"; }
                }
                scroll {
                    bind "Alt s" "Esc" { ScrollToBottom; SwitchToMode "Normal"; }
                    bind "Enter" { SwitchToMode "Normal"; }
                    bind "e" { EditScrollback; SwitchToMode "Normal"; }
                    bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
                    bind "j" { ScrollDown; }
                    bind "k" { ScrollUp; }
                    bind "d" { HalfPageScrollDown; }
                    bind "u" { HalfPageScrollUp; }
                }
                entersearch {
                    bind "Esc" { SwitchToMode "Normal"; }
                    bind "Enter" { SwitchToMode "Search"; }
                }
                search {
                    bind "Alt s" "Esc" { SwitchToMode "Normal"; }
                    bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
                    bind "j" { ScrollDown; }
                    bind "k" { ScrollUp; }
                    bind "d" { HalfPageScrollDown; }
                    bind "u" { HalfPageScrollUp; }
                    bind "n" { Search "Down"; }
                    bind "p" { Search "Up"; }
                    bind "c" { SearchToggleOption "CaseSensitivity"; }
                    bind "w" { SearchToggleOption "Wrap"; }
                    bind "o" { SearchToggleOption "WholeWord"; }
                }
                session {
                    bind "Alt o" "Esc" { SwitchToMode "Normal"; }
                    bind "d" { Detach; }
                    bind "q" { Quit; }
                    bind "w" {
                        LaunchOrFocusPlugin "session-manager" {
                            floating true
                            move_to_focused_tab true
                        };
                        SwitchToMode "Normal"
                    }
                    bind "p" {
                        LaunchOrFocusPlugin "plugin-manager" {
                            floating true
                            move_to_focused_tab true
                        };
                        SwitchToMode "Normal"
                    }
                }
                tab {
                    bind "Alt t" "Esc" { SwitchToMode "Normal"; }
                    bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
                    bind "x" { CloseTab; SwitchToMode "Normal"; }
                    bind "." { GoToNextTab; }
                    bind "," { GoToPreviousTab; }
                    bind ">" { MoveTab "Right"; }
                    bind "<" { MoveTab "Left"; }
                    bind "n" { NewTab; SwitchToMode "Normal"; }
                    bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
                    bind "b" { BreakPane; SwitchToMode "Normal"; }
                    bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
                    bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
                }
                renametab {
                    bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
                    bind "Enter" { SwitchToMode "Normal"; }
                }
                shared_except "locked" {
                    bind "Alt h" { MoveFocusOrTab "Left"; }
                    bind "Alt j" { MoveFocus "Down"; }
                    bind "Alt k" { MoveFocus "Up"; }
                    bind "Alt l" { MoveFocusOrTab "Right"; }
                    bind "Alt ." { GoToNextTab; }
                    bind "Alt ," { GoToPreviousTab; }
                    bind "Alt >" { MoveTab "Right"; }
                    bind "Alt <" { MoveTab "Left"; }
                    bind "Alt f" { ToggleFocusFullscreen; }
                    bind "Alt g" { SwitchToMode "Locked"; }
                    bind "Alt r" { SwitchToMode "Resize"; }
                    bind "Alt o" { SwitchToMode "Session"; }
                    bind "Alt p" { SwitchToMode "Pane"; }
                    bind "Alt s" { SwitchToMode "Scroll"; }
                    bind "Alt t" { SwitchToMode "Tab"; }
                    bind "Alt c" { Run "zellij" "run" "--floating" "--close-on-exit" "--" "numbat"; }
                }
            }

            pane_frames true
            theme "catppuccin-frappe"

            ui {
                pane_frames {
                    hide_session_name true
                    rounded_corners true
                }
            }
        '';

        xdg.configFile."zellij/layouts/default.kdl".text = /* kdl */ ''
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        plugin location="file:/nix/store/fsx1pqsl6qg67s393nlvxnvnwzjfqslx-zjstatus-0.19.0/bin/zjstatus.wasm" {
                            hide_frame_for_single_pane "false"
                            border_enabled "true"
                            format_left   "{mode}#[fg=black]{tabs}"
                            format_center ""
                            format_right  ""
                            format_space  "#[fg=yellow] "

                            // mode_normal  "#[fg=red]  "
                            mode_normal  "#[fg=blue]  "
                            mode_locked  "#[fg=red]  "

                            // formatting for inactive tabs
                            tab_normal              "#[fg=#6C7086]{name}"
                            tab_normal_fullscreen   "#[fg=#6C7086]{name}"
                            tab_normal_sync         "#[fg=#6C7086]{name}"

                            // formatting for the current active tab
                            tab_active              "#[fg=blue,bold]{name}#[fg=yellow,bold]{floating_indicator}"
                            tab_active_fullscreen   "#[fg=yellow,bold]{name}#[fg=yellow,bold]{fullscreen_indicator}"
                            tab_active_sync         "#[fg=green,bold]{name}#[fg=yellow,bold]{sync_indicator}"

                            // separator between the tabs
                            tab_separator           "#[fg=cyan,bold] ⋮ "

                            // indicators
                            tab_sync_indicator       " "
                            tab_fullscreen_indicator " "
                            tab_floating_indicator   ""
                        }
                    }
                }
            }
        '';

        xdg.configFile."zellij/layouts/dev.kdl".text = /* kdl */ ''
            layout {
                tab {
                    pane split_direction="horizontal" {
                        pane split_direction="vertical" {
                            pane {
                                size 36
                                pane {
                                    command "yazi"
                                    name "Yazi"
                                    focus true
                                }
                                pane {
                                    command "lazygit"
                                    name "Lazygit"
                                }
                            }
                            pane split_direction="horizontal" {
                                pane {
                                    command "hx"
                                    args "."
                                    name "Helix"
                                }
                                pane {
                                    size 10
                                    command "fish"
                                    name "Console"
                                }
                            }
                        }
                    }
                    pane size=1 borderless=true {
                        plugin location="file:/nix/store/fsx1pqsl6qg67s393nlvxnvnwzjfqslx-zjstatus-0.19.0/bin/zjstatus.wasm" {
                            hide_frame_for_single_pane "false"
                            border_enabled "true"
                            format_left   "{mode}#[fg=black]{tabs}"
                            format_center ""
                            format_right  ""
                            format_space  "#[fg=yellow] "

                            mode_normal  "#[fg=blue]  "
                            mode_locked  "#[fg=red]  "

                            // formatting for inactive tabs
                            tab_normal              "#[fg=#6C7086]{name}"
                            tab_normal_fullscreen   "#[fg=#6C7086]{name}"
                            tab_normal_sync         "#[fg=#6C7086]{name}"

                            // formatting for the current active tab
                            tab_active              "#[fg=blue,bold]{name}#[fg=yellow,bold]{floating_indicator}"
                            tab_active_fullscreen   "#[fg=yellow,bold]{name}#[fg=yellow,bold]{fullscreen_indicator}"
                            tab_active_sync         "#[fg=green,bold]{name}#[fg=yellow,bold]{sync_indicator}"

                            // separator between the tabs
                            tab_separator           "#[fg=cyan,bold] ⋮ "

                            // indicators
                            tab_sync_indicator       " "
                            tab_fullscreen_indicator " "
                            tab_floating_indicator   ""
                        }
                    }
                }
            }
        '';

    };

}

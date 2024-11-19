{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ zellijPlugins.zjstatus ];

        programs.fish.shellAliases."dev" = let

            buildDevLayout = pkgs.writeShellScript "buildDevLayout.sh" /* bash */ ''
                zellij --layout dev
                zellij action write-chars "+"
                zellij action move-focus down
                zellij action write-chars "+"
                zellij action move-focus down
                zellij action write-chars "clear"
                zellij action write 10
                zellij action move-focus up
                zellij action move-focus up
                zellij action move-focus right
            '';

        in "${pkgs.bash}/bin/bash ${buildDevLayout}";

        programs.zellij.enable = true;
        programs.zellij.enableFishIntegration = true;

        xdg.configFile."zellij/config.kdl".text = /* kdl */ ''
            copy_clipboard "primary"
            copy_command "wl-copy"
            copy_on_select true
            default_layout "compact"

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
                    bind "n" { NewPane "Right"; SwitchToMode "Normal"; }
                    bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
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
                }
            }

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
                pane split_direction="vertical" {
                    pane
                }
                pane size=1 borderless=true {
                    plugin location="file:${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm" {
                        hide_frame_for_single_pane "true"
                        format_left  "{mode}#[fg=#89B4FA,bg=#181825,bold] {tabs}"
                        format_right "#[fg=#424554,bg=#181825]{session}"
                        format_space "#[bg=#181825]"

                        mode_normal          "#[fg=black,bg=#89B4FA] NORMAL #[fg=#87B4FA,bg=#181825]"
                        mode_tmux            "#[fg=black,bg=#FFC387] TMUX #[fg=#FFC387,bg=#181825]"
                        // mode_default_to_mode "tmux"

                        tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
                        tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
                        tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
                        tab_active              "#[fg=#181825,bg=#ffffff,bold,italic] {index}  {name} #[fg=#ffffff,bg=#181825]"
                        tab_active_fullscreen   "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} [] "
                        tab_active_sync         "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} <> "
                    }
                }
            }
        '';

        xdg.configFile."zellij/layouts/dev.kdl".text = /* kdl */ ''
            layout {
                pane split_direction="horizontal" {
                    pane split_direction="vertical" {
                        pane {
                            size 36
                            pane {
                                command "yazi"
                                name "Yazi"
                                close_on_exit true
                                focus true
                            }
                            pane {
                                command "lazygit"
                                name "Lazygit"
                                close_on_exit true
                            }
                            pane {
                                size 14
                                command "numbat"
                                name "Calculator"
                                close_on_exit true
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
                                close_on_exit true
                            }
                        }
                    }
                }
                pane size=1 borderless=true {
                    plugin location="file:${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm" {
                        hide_frame_for_single_pane "true"
                        format_left  "{mode}#[fg=#89B4FA,bg=#181825,bold] {tabs}"
                        format_right "#[fg=#424554,bg=#181825]{session}"
                        format_space "#[bg=#181825]"

                        mode_normal          "#[fg=black,bg=#89B4FA] NORMAL #[fg=#87B4FA,bg=#181825]"
                        mode_tmux            "#[fg=black,bg=#FFC387] TMUX #[fg=#FFC387,bg=#181825]"
                        // mode_default_to_mode "tmux"

                        tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
                        tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
                        tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
                        tab_active              "#[fg=#181825,bg=#ffffff,bold,italic] {index}  {name} #[fg=#ffffff,bg=#181825]"
                        tab_active_fullscreen   "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} [] "
                        tab_active_sync         "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} <> "
                    }
                }
            }
        '';

    };

}

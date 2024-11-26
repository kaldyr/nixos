{ pkgs, sysConfig, ... }: let

    statusPane = /* kdl */ ''
        pane size=1 borderless=true {
            plugin location="file:${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm" {
                hide_frame_for_single_pane "true"
                hide_frame_except_for_search "false"
                hide_frame_except_for_fullscreen "false"

                format_left   "{mode}  #[fg=black]{tabs}"
                format_center ""
                format_right  ""
                format_space  ""

                mode_enter_search "#[fg=blue] "
                mode_locked       "#[fg=red] "
                mode_move         "#[fg=yellow] "
                mode_normal       "#[fg=blue] "
                mode_pane         "#[fg=green] "
                mode_rename_pane  "#[fg=green] 󱩼"
                mode_rename_tab   "#[fg=magenta] 󱩼"
                mode_resize       "#[fg=yellow] 󰩨"
                mode_scroll       "#[fg=cyan] "
                mode_search       "#[fg=blue] "
                mode_session      "#[fg=yellow] 󰖲"
                mode_tab          "#[fg=magenta] 󰓩"

                // formatting for inactive tabs
                tab_normal            "#[fg=black]{name}"
                tab_normal_fullscreen "#[fg=black]{name}"
                tab_normal_sync       "#[fg=black]{name}"

                // formatting for the current active tab
                tab_active            "#[fg=blue,bold]{name}#[fg=yellow,bold]{floating_indicator}"
                tab_active_fullscreen "#[fg=yellow,bold]{name}#[fg=yellow,bold]{fullscreen_indicator}"
                tab_active_sync       "#[fg=green,bold]{name}#[fg=yellow,bold]{sync_indicator}"

                // separator between the tabs
                tab_separator "#[fg=cyan,bold]  ⋮  "

                // indicators
                tab_sync_indicator       "  "
                tab_fullscreen_indicator "  "
                tab_floating_indicator   "  "
            }
        }
    '';

in {

    environment.persistence."/nix".users.${sysConfig.user}.files = [ ".cache/zellij/permissions.kdl" ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ zellijPlugins.zjstatus ];

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
                move {
                    bind "Alt m" "Esc" "Enter" { SwitchToMode "Normal"; }
                    bind "h" { MovePane "Left"; }
                    bind "j" { MovePane "Down"; }
                    bind "k" { MovePane "Up"; }
                    bind "l" { MovePane "Right"; }
                }
                pane {
                    bind "Alt p" "Esc" "Enter" { SwitchToMode "Normal"; }
                    bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
                    bind "n" { NewPane "Down"; SwitchToMode "Normal"; }
                    bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; }
                    bind "x" { CloseFocus; SwitchToMode "Normal"; }
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
                }
                tab {
                    bind "Alt t" "Esc" { SwitchToMode "Normal"; }
                    bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
                    bind "x" { CloseTab; SwitchToMode "Normal"; }
                    bind "n" { NewTab; SwitchToMode "Normal"; }
                    bind "N" { NewTab { cwd "~"; }; SwitchToMode "Normal"; }
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
                    bind "Alt h" { MoveFocus "Left"; }
                    bind "Alt j" { MoveFocus "Down"; }
                    bind "Alt k" { MoveFocus "Up"; }
                    bind "Alt l" { MoveFocus "Right"; }
                    bind "Alt ." { GoToNextTab; }
                    bind "Alt ," { GoToPreviousTab; }
                    bind "Alt >" { MoveTab "Right"; }
                    bind "Alt <" { MoveTab "Left"; }
                    bind "Alt 1" { GoToTab 1; }
                    bind "Alt 2" { GoToTab 2; }
                    bind "Alt 3" { GoToTab 3; }
                    bind "Alt 4" { GoToTab 4; }
                    bind "Alt 5" { GoToTab 5; }
                    bind "Alt 6" { GoToTab 6; }
                    bind "Alt 7" { GoToTab 7; }
                    bind "Alt 8" { GoToTab 8; }
                    bind "Alt 9" { GoToTab 9; }
                    bind "Alt 0" { GoToTab 10; }
                    bind "Alt f" { ToggleFocusFullscreen; }
                    bind "Alt g" { SwitchToMode "Locked"; }
                    bind "Alt m" { SwitchToMode "Move"; }
                    bind "Alt o" { SwitchToMode "Session"; }
                    bind "Alt p" { SwitchToMode "Pane"; }
                    bind "Alt r" { SwitchToMode "Resize"; }
                    bind "Alt s" { SwitchToMode "Scroll"; }
                    bind "Alt t" { SwitchToMode "Tab"; }
                    bind "Alt w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
                    bind "Alt c" {
                        Run "numbat" {
                            name "Calculator"
                            floating true
                            close_on_exit true
                        };
                        SwitchToMode "Normal"
                    }
                    bind "Alt y" {
                        Run "yazi" {
                            name "Yazi"
                            floating true
                            close_on_exit true
                        };
                        SwitchToMode "Normal"
                    }
                }
            }

            pane_frames true
            session_serialization false

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
                    ${statusPane}
                }
                tab name=""
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
                                    command "nvim"
                                    args "."
                                    name "Neovim"
                                }
                                pane {
                                    size 10
                                    command "fish"
                                    name "Console"
                                }
                            }
                        }
                    }
                    ${statusPane}
                }
            }
        '';

    };

}

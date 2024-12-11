{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user} = {
            directories = [ ".config/helix/runtime" ];
            files = [ ".cache/helix/helix.log" ];
        };
    };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            lua-language-server
            marksman
            helix
            nil
        ];

        xdg.configFile."helix/config.toml".text = /* toml */ ''
            theme = "catppuccin_frappe"

            [editor]
            auto-completion = true
            bufferline = "multiple"
            completion-timeout = 5
            completion-trigger-len = 2
            line-number = "relative"
            indent = { tab-width = 4, unit = "\t" }
            scrolloff = 3

            [editor.cursor-shape]
            insert = "bar"
            normal = "block"
            select = "underline"

            [editor.indent-guides]
            render = true
            character = "▏"

            [editor.smart-tab]
            enable = false

            [editor.statusline]
            left = [ "spinner", "file-name", "file-encoding" ]
            center = []
            right = [ "diagnostics", "register", "position-percentage", "position", "file-type" ]

            [editor.whitespace.render]
            nbsp = "all"
            newline = "none"
            nnbsp = "all"
            space = "all"
            tab = "all"

            [editor.whitespace.characters]
            nbsp = "⍽"
            nnbsp = "␣"
            space = "·"
            tab = "→"
            tabpad = "·"
            newline = "⏎"

            [keys.normal]
            # Muscle memory
            "{" = ["goto_prev_paragraph", "collapse_selection"]
            "}" = ["goto_next_paragraph", "collapse_selection"]
            0 = "goto_line_start"
            "$" = "goto_line_end"
            "^" = "goto_first_nonwhitespace"
            G = "goto_file_end"
            V = ["select_mode", "extend_to_line_bounds"]
            C = ["extend_to_line_end", "yank_main_selection_to_clipboard", "delete_selection", "insert_mode"]
            D = ["extend_to_line_end", "yank_main_selection_to_clipboard", "delete_selection"]
            S = "surround_add"

            # Clipboards over registers
            x = "delete_selection"
            p = ["paste_clipboard_after", "collapse_selection"]
            P = ["paste_clipboard_before", "collapse_selection"]
            Y = ["extend_to_line_end", "yank_main_selection_to_clipboard", "collapse_selection"]

            i = ["collapse_selection", "insert_mode"]
            a = ["collapse_selection", "append_mode"]

            # Undoing the 'd' + motion commands restores the selection which is annoying
            u = ["undo", "collapse_selection"]

            # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
            esc = ["collapse_selection", "keep_primary_selection"]

            # Search for word under cursor
            "*" = ["move_char_right", "move_prev_word_start", "move_next_word_end", "search_selection", "search_next"]
            "#" = ["move_char_right", "move_prev_word_start", "move_next_word_end", "search_selection", "search_prev"]

            # Make j and k behave as they do Vim when soft-wrap is enabled
            j = "move_line_down"
            k = "move_line_up"

            up = [ # scroll selections up one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "move_line_up",
                "add_newline_above",
                "move_line_up",
                "replace_with_yanked",
                "collapse_selection" ]

            down = [ # scroll selections down one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "add_newline_below",
                "move_line_down",
                "replace_with_yanked",
                "collapse_selection" ]

            [keys.normal.d]
            d = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection"]
            t = ["extend_till_char"]
            s = ["surround_delete"]
            i = ["select_textobject_inner"]
            a = ["select_textobject_around"]
            j = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
            down = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
            k = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
            up = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
            G = ["select_mode", "extend_to_line_bounds", "goto_last_line", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"]
            w = ["move_next_word_start", "yank_main_selection_to_clipboard", "delete_selection"]
            W = ["move_next_long_word_start", "yank_main_selection_to_clipboard", "delete_selection"]
            g = { g = ["select_mode", "extend_to_line_bounds", "goto_file_start", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "delete_selection", "normal_mode"] }

            [keys.normal.y]
            y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "normal_mode", "collapse_selection"]
            j = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            down = ["select_mode", "extend_to_line_bounds", "extend_line_below", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            k = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            up = ["select_mode", "extend_to_line_bounds", "extend_line_above", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            G = ["select_mode", "extend_to_line_bounds", "goto_last_line", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            w = ["move_next_word_start", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            W = ["move_next_long_word_start", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"]
            g = { g = ["select_mode", "extend_to_line_bounds", "goto_file_start", "extend_to_line_bounds", "yank_main_selection_to_clipboard", "collapse_selection", "normal_mode"] }

            [keys.insert]
            esc = ["collapse_selection", "normal_mode"]

            [keys.select]
            # Muscle memory
            "{" = ["extend_to_line_bounds", "goto_prev_paragraph"]
            "}" = ["extend_to_line_bounds", "goto_next_paragraph"]
            0 = "goto_line_start"
            "$" = "goto_line_end"
            "^" = "goto_first_nonwhitespace"
            G = "goto_file_end"
            D = ["extend_to_line_bounds", "delete_selection", "normal_mode"]
            C = ["goto_line_start", "extend_to_line_bounds", "change_selection"]
            "%" = "match_brackets"
            S = "surround_add"
            u = ["switch_to_lowercase", "collapse_selection", "normal_mode"]
            U = ["switch_to_uppercase", "collapse_selection", "normal_mode"]

            # Visual-mode specific muscle memory
            i = "select_textobject_inner"
            a = "select_textobject_around"

            # Make selecting lines in visual mode behave sensibly
            k = ["extend_line_up", "extend_to_line_bounds"]
            j = ["extend_line_down", "extend_to_line_bounds"]

            # Clipboards over registers
            d = ["yank_main_selection_to_clipboard", "delete_selection"]
            x = ["yank_main_selection_to_clipboard", "delete_selection"]
            y = ["yank_main_selection_to_clipboard", "normal_mode", "flip_selections", "collapse_selection"]
            Y = ["extend_to_line_bounds", "yank_main_selection_to_clipboard", "goto_line_start", "collapse_selection", "normal_mode"]
            p = "replace_selections_with_clipboard"
            P = "paste_clipboard_before"

            up = [ # scroll selections up one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "move_line_up",
                "add_newline_above",
                "move_line_up",
                "replace_with_yanked",
                "select_mode" ]

            down = [ # scroll selections down one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "add_newline_below",
                "move_line_down",
                "replace_with_yanked",
                "select_mode" ]

            # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
            esc = ["collapse_selection", "keep_primary_selection", "normal_mode"]
        '';

        xdg.configFile."helix/languages.toml".text = /* toml */ ''
            [[language]]
            name = "yaml"
            auto-format = true
            indent = { tab-width = 2, unit = " " }

            [[language]]
            name = "html"
            auto-format = true
            indent = { tab-width = 2, unit = "\t" }

            [[language]]
            name = "templ"
            auto-format = true
            indent = { tab-width = 2, unit = "\t" }
        '';

    };

}

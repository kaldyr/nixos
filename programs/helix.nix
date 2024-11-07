{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user} = {
        directories = [ ".config/helix/runtime" ];
        files = [ ".cache/helix/helix.log" ];
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
            scrolloff = 3

            [editor.cursor-shape]
            insert = "bar"
            normal = "block"
            select = "underline"

            [editor.indent-guides]
            render = true
            character = "▏"
            skip-levels = 1

            [editor.statusline]
            left = [
                "spinner",
                "file-name",
                "file-encoding"
            ]
            center = []
            right = [
                "diagnostics",
                "register",
                "position-percentage",
                "position",
                "file-type"
            ]

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

            [keys.select]
            C-k = [ # scroll selections up one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "move_line_up",
                "add_newline_above",
                "move_line_up",
                "replace_with_yanked",
                "select_mode"
            ]

            C-j = [ # scroll selections down one line
                "ensure_selections_forward",
                "extend_to_line_bounds",
                "extend_char_right",
                "extend_char_left",
                "delete_selection",
                "add_newline_below",
                "move_line_down",
                "replace_with_yanked",
                "select_mode"
            ]
        '';

        xdg.configFile."helix/languages.toml".text = /* toml */ ''
            [[language]]
            name = "yaml"
            auto-format = true
            indent = { tab-width = 2, unit = " " }

            [[language]]
            name = "html"
            auto-format = true
            indent = { tab-width = 2, unit = " " }

            [[language]]
            name = "templ"
            auto-format = true
            indent = { tab-width = 2, unit = " " }
        '';

    };

}

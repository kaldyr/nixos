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
            completion-timeout = 5
            line-number = "relative"
            bufferline = "multiple"

            [editor.cursor-shape]
            insert = "bar"
            normal = "block"
            select = "underline"

            [editor.indent-guides]
            render = true
            character = "▏"
            skip-levels = 1

            [editor.whitespace.render]
            space = "all"
            tab = "all"
            nbsp = "all"
            nnbsp = "all"
            newline = "none"

            [editor.whitespace.characters]
            space = "·"
            nbsp = "⍽"
            nnbsp = "␣"
            tab = "→"
            tabpad = "·"
            # Figure out how to show spaces at the end of a line

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

            # [[language]]
            # name = "yaml"
            # auto-format = true
            # indent = { tab-width = 2, unit = " " }
        '';

    };

}

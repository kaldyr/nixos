{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.starship.enable = true;
        # programs.starship.enableFishIntegration = true;
        programs.starship.enableNushellIntegration = true;

        xdg.configFile."starship.toml".text = /* toml */ ''
            format = "$all"
            palette = "catppuccin_frappe"

            [character]
            error_symbol = "[󰊠](bold red)"
            format = "$symbol [|](bold bright-black) "
            vicmd_symbol = "[󰊠](bold yellow) "

            [directory]
            read_only = "󰌾"

            [git_commit]
            commit_hash_length = 7

            [golang]
            symbol = "[](rosewater) "

            [lua]
            symbol = "[](blue) "

            [python]
            symbol = "[](yellow) "

            [palettes.catppuccin_frappe]
            base = "#303446"
            blue = "#8caaee"
            crust = "#232634"
            flamingo = "#eebebe"
            green = "#a6d189"
            lavender = "#babbf1"
            mantle = "#292c3c"
            maroon = "#ea999c"
            mauve = "#ca9ee6"
            overlay0 = "#737994"
            overlay1 = "#838ba7"
            overlay2 = "#949cbb"
            peach = "#ef9f76"
            pink = "#f4b8e4"
            red = "#e78284"
            rosewater = "#f2d5cf"
            sapphire = "#85c1dc"
            sky = "#99d1db"
            subtext0 = "#a5adce"
            subtext1 = "#b5bfe2"
            surface0 = "#414559"
            surface1 = "#51576d"
            surface2 = "#626880"
            teal = "#81c8be"
            text = "#c6d0f5"
            yellow = "#e5c890"
        '';

    };

}

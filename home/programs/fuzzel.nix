{

    programs.fuzzel = {

        enable = true;

        settings = {

            colors = {
                background = "303446e6";
                text = "c6d0f5ff";
                match = "81c8beff";
                selection = "626880ff";
                selection-match = "81c8beff";
                selection-text = "c6d0f5ff";
                border = "babbf1ff";
            };

            main = {
                filter-desktop = true;
                font = "Inter:size=10";
                fuzzy = "yes";
                icon-theme = "Papirus";
                icons-enabled = "yes";
                image-size-ratio = "1.0";
                inner-pad = 8;
                layer = "overlay";
                letter-spacing = 0;
                line-height = 24;
                lines = 10;
                prompt = ''"❄️ ❯ "'';
                terminal = "wezterm";
                width = 60;
            };

        };

    };

}

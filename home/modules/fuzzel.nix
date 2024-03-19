{

    programs.fuzzel = {

        enable = true;

        settings = {

            colors = {
                background = "303446cc";
                text = "c6d0f5ff";
                match = "81c8beff";
                selection = "626880ff";
                selection-match = "81c8beff";
                selection-text = "c6d0f5ff";
                border = "babbf1ff";
            };

            main = {
                filter-desktop = true;
                font = "Ubuntu Nerd Font:size=8";
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
                terminal = "foot";
                width = 60;
            };

        };

    };

}

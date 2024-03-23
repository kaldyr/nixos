{

    programs.yazi = {

        enable = true;

        enableFishIntegration = true;

        keymap = {
            manager.prepend_keymap = [
                { on = [ "<C-k>" ]; run = "seek -5"; desc = "Seek up 5 units in the preview"; }
                { on = [ "<C-j>" ]; run = "seek 5"; desc = "Seek down 5 units in the preview"; }
            ];
        };

        settings = {

            manager = {
                ratio = [ 2 2 4 ];
                show_hidden = false;
                show_symlink = true;
                sort_by = "natural";
                sort_dir_first = true;
                sort_reverse = false;
            };

            open.rules = [
                { mime = "application/pdf"; use = "pdf"; }
                { mime = "audio/*"; use = "audio"; }
                { mime = "image/*"; use = "image"; }
                { mime = "text/*"; use = "text"; }
                { mime = "video/*"; use = "video"; }
            ];

            opener = {
                audio = [{ run = "mpv \"$@\""; desc = "Play with mpv"; orphan = true; }];
                video = [{ run = "mpv \"$@\""; desc = "Play with mpv"; orphan = true; }];
                image = [{ run = "feh -. -Z \"$@\""; desc = "Open with feh"; orphan = true; }];
                pdf = [{ run = "zathura \"$@\""; desc = "Open with Zathura"; orphan = true; }];
                folder = [{ run = "nvim \"$@\""; desc = "Edit with NeoVim"; block = true; }];
                text = [{ run = "nvim \"$@\""; desc = "Edit with NeoVim"; block = true; }];
                fallback = [
                    { run = "xdg-open \"$@\""; desc = "XDG Open"; orphan = true; }
                    { run = "nvim \"$@\""; desc = "Edit with NeoVim"; block = true; }
                ];
            };

        };

    };

}

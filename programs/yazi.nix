{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.yazi.enable = true;
        programs.yazi.enableFishIntegration = true;

        xdg.configFile = {

            "yazi/keymap.toml".text = /* toml */ ''
                [[manager.prepend_keymap]]
                desc = "Seek up 5 units in the preview"
                on = ["<C-k>"]
                run = "seek -5"

                [[manager.prepend_keymap]]
                desc = "Seek down 5 units in the preview"
                on = ["<C-j>"]
                run = "seek 5"
            '';

            "yazi/yazi.toml".text = /* toml */ ''
                [manager]
                ratio = [2, 2, 4]
                show_hidden = false
                show_symlink = true
                sort_by = "natural"
                sort_dir_first = true
                sort_reverse = false

                [open]
                rules = [
                    { mime = "inode/directory", use = ["text", "play"] },
                    { mime = "application/pdf", use = "pdf" },
                    { mime = "audio/*", use = "play" },
                    { mime = "image/*", use = "image" },
                    { mime = "text/*", use = "text" },
                    { mime = "video/*", use = "play" },
                ]

                [opener]
                fallback = [
                    { desc = "XDG Open", orphan = true, run = "xdg-open \"$@\"" },
                    { block = true, desc = "Edit with NeoVim", run = "nvim \"$@\"" },
                ]
                folder = [
                    { desc = "Play with mpv", orphan = true, run = "mpv \"$@\"" },
                    { block = true, desc = "Edit with NeoVim", run = "nvim \"$@\"" },
                ]
                image = [ { desc = "Open with feh", orphan = true, run = "feh -. -Z \"$@\"" } ]
                pdf = [ { desc = "Open with Zathura", orphan = true, run = "zathura \"$@\"" } ]
                play = [ { desc = "Play with mpv", orphan = true, run = "mpv \"$@\"" } ]
                text = [ { block = true, desc = "Edit with NeoVim", run = "nvim \"$@\"" } ]
            '';

        };

    };

}

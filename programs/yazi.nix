{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ mediainfo ];

        programs.yazi.enable = true;
        programs.yazi.enableFishIntegration = true;

        xdg.configFile."yazi/keymap.toml".text = /* toml */ ''
            [manager]
            prepend_keymap = [
                { on = "<C-k>", run = "seek -5", desc = "Seek up 5 units in the preview" },
                { on = "<C-j>", run = "seek 5", desc = "Seek down 5 units in the preview" },
            ]
        '';

        xdg.configFile."yazi/yazi.toml".text = /* toml */ ''
            [manager]
            linemode = "size"
            mouse_events = [ "click", "scroll" ]
            ratio = [1, 3, 4]
            scrolloff = 5
            show_hidden = false
            show_symlink = true
            sort_by = "natural"
            sort_dir_first = true
            sort_reverse = false
            sort_sensitive = false
            sort_translit = false
            title_format = "Yazi: {cwd}"

            [preview]
            cache_dir = ""
            image_delay = 50
            image_filter = "triangle"
            image_quality = 75
            max_height = 900
            max_width = 600
            sixel_fraction = 15
            tab_size = 2
            ueberzug_offset = [ 0, 0, 0, 0 ]
            ueberzug_scale = 1
            wrap = "no"

            [opener]
            edit = [ { run = 'nvim "$@"', desc = "Edit", block = true } ]
            exif = [ { run = 'exiftool "$1"; echo "Press enter to exit"; read _', desc = "Show EXIF data", block = true } ]
            exifedit = [
                { run = 'exiftool -overwrite_original "-alldates<filename" -S -m -q "$1"', desc = "Set EXIF datetime from Filename" },
                { run = 'exiftool "-filename<CreateDate" -d "_%Y%m%d_%H%M%S.%%e" -S -m -ee -q "$1"', desc = "Set Filename from EXIF datetime" },
            ]
            extract = [ { run = 'ya pub extract --list "$@"', desc = "Extract Here" } ]
            foldersize = [ { run = 'du -hs "$@"; echo "Press enter to exit"; read _', desc = "Folder size", block = true } ]
            image = [ { run = 'feh -. -Z "$@"', desc = "Open with feh", orphan = true } ]
            office = [ { run = 'libreoffice "$@"', desc = "Open with LibreOffice", orphan = true } ]
            open = [ { run = 'xdg-open "$1"', desc = "XDG Open", orphan = true } ]
            pdf = [ { run = 'zathura "$@"', desc = "Open with Zathura", orphan = true } ]
            play = [
                { run = 'mpv --force-window "$@"', desc = "Play with mpv", orphan = true },
                { run = 'mediainfo "$1"; echo "Press enter to exit"; read _', desc = "Show media info", block = true },
            ]

            [open]
            rules = [
                { mime = "application/{,g}zip", use = [ "extract", "exif" ] },
                { mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", use = [ "extract", "exif" ] },
                { mime = "application/pdf", use = [ "pdf", "exif" ] },
                { mime = "audio/*", use = [ "play", "exif" ] },
                { mime = "image/*", use = [ "image", "exif", "exifedit" ] },
                { mime = "inode/directory", use = [ "edit", "play", "foldersize" ] },
                { mime = "text/*", use = [ "edit", "exif" ] },
                { mime = "video/*", use = [ "play", "exif", "exifedit" ] },
                { name = "*.od{g,p,s,t}", use = [ "office", "exif" ] },
                { name = "*.doc{,x}", use = [ "office", "exif" ] },
                { name = "*.ppt{,x}", use = [ "office", "exif" ] },
                { name = "*.xls{,x}", use = [ "office", "exif" ] },
                { mime = "*", use = [ "open", "edit", "exif" ] },
            ]

            [tasks]
            micro_workers = 10
            macro_workers = 25
            bizarre_retry = 5
            image_alloc = 536870912  # 512MB
            image_bound = [ 0, 0 ]
            suppress_preload = false

            [log]
            enabled = false
        '';

    };

}

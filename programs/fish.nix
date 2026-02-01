{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/fish/generated_completions"
            ".config/fish"
            ".local/share/fish"
        ];
    };

    home-manager.users.${sysConfig.user} = {

        programs.fish = {

            enable = true;

            functions.fish_greeting = "";

            interactiveShellInit = /* fish */ ''
                fish_vi_key_bindings insert
                set -gx fish_cursor_default block
                set -gx fish_cursor_insert line
                set -gx fish_cursor_visual block
                set -gx fish_cursor_replace_one underscore
                set fish_vi_force_cursor 1
                fish_vi_cursor
                bind -M insert \cA beginning-of-line
                bind -M insert \cE end-of-line
                bind yy fish_clipboard_copy
                bind p fish_clipboard_paste
                bind -M visual y fish_clipboard_copy
                bind -M visual p fish_clipboard_paste
                bind \cl 'clear -x ; tput cup $COLUMNS 0 ; commandline -f repaint'
                bind -M insert \cl 'clear -x ; tput cup $COLUMNS 0 ; commandline -f repaint'
                tput cup $COLUMNS 0
            '';

            plugins = [
                { name = "autopair"; src = pkgs.fishPlugins.autopair; }
                { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish; }
                { name = "puffer"; src = pkgs.fishPlugins.puffer; }
                { name = "sponge"; src = pkgs.fishPlugins.sponge; }
            ];

            shellAliases = {
                sourcefish = "source ~/.config/fish/config.fish && fish_logo";
                "!!" = "eval \\$history[1]";
                cat = "bat";
                cp = "cp -i";
                df = "duf";
                du = "du -hs";
                ln = "ln -i";
                mkdir = "mkdir -pv";
                mv = "mv -i";
                rm = "rm -i";
            };

            shellInit = /* fish */ ''
                fish_config theme choose "Catppuccin Frappe"
            '';

        };

        xdg = {

            configFile."fish/themes/Catppuccin Frappe.theme".source = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "fish";
                rev = "521560ce2075ca757473816aa31914215332bac9";
                sha256 = "sha256-5CXdzym6Vp+FbKTVBtVdWoh3dODudADIzOLXIyIIxgQ=";
            } + "/themes/Catppuccin Frappe.theme";

            desktopEntries.fish = { name = "Fish Shell"; noDisplay = true; };

        };

    };

    programs.fish.enable = true;

}

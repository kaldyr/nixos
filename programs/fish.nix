{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
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
                bind -M insert \cA beginning-of-line
                bind -M insert \cE end-of-line
                bind yy fish_clipboard_copy
                bind p fish_clipboard_paste
                bind -M visual y fish_clipboard_copy
                bind -M visual p fish_clipboard_paste
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
                rev = "cc8e4d8fffbdaab07b3979131030b234596f18da";
                sha256 = "sha256-udiU2TOh0lYL7K7ylbt+BGlSDgCjMpy75vQ98C1kFcc=";
            } + "/themes/Catppuccin Frappe.theme";

            desktopEntries.fish = { name = "Fish Shell"; noDisplay = true; };

        };

    };

    programs.fish.enable = true;

}

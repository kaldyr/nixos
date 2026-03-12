{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/fish/generated_completions"
            ".config/fish"
            ".local/share/fish"
        ];
    };

    home-manager.users.${sysConfig.user} = {

        programs.zsh = {

            enable = true;

            plugins = [
                { name = "autopair"; src = pkgs.fishPlugins.autopair; }
                { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish; }
                { name = "puffer"; src = pkgs.fishPlugins.puffer; }
                { name = "sponge"; src = pkgs.fishPlugins.sponge; }
            ];

            shellAliases = {
                "!!" = "eval \\$history[1]";
                cp = "cp -i";
                df = "duf";
                du = "du -hs";
                ln = "ln -i";
                ls = "g -1 --color basic --dir-first --git --icon";
                ll = "ls --long";
                la = "ls --long --almost-all";
                lla = "ls --long --almost-all";
                l = "ls";
                mkdir = "mkdir -pv";
                mv = "mv -i";
                rm = "rm -i";
            };

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

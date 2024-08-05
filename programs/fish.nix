{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [
            ".config/fish"
            ".local/share/fish"
        ];
    };

    home-manager.users.${sysConfig.user} = {

        programs.fish = {

            enable = true;

            functions.fish_greeting = "";

            interactiveShellInit = ''
                bind \cl 'clear ; tput cup $(tput lines) ; commandline -f repaint'
                tput cup $(tput lines) ; commandline -f repaint
            '';

            shellAliases = {
                sourcefish = "source ~/.config/fish/config.fish && fish_logo";
                "!!" = "eval \\$history[1]";
                bc = "bc -l";
                cat = "bat";
                cp = "cp -i";
                df = "duf";
                du = "du -hs";
                l = "yazi";
                ln = "ln -i";
                mkdir = "mkdir -pv";
                mv = "mv -i";
                rm = "rm -i";
            };

            shellInit = ''
                fish_config theme choose "Catppuccin Frappe"
            '';

        };

        xdg = {
        
            configFile."fish/themes/Catppuccin Frappe.theme".source = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "fish";
                rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
                sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
            } + "/themes/Catppuccin Frappe.theme";

            desktopEntries.fish = { name = "Fish Shell"; noDisplay = true; };

        };

    };

    programs.fish.enable = true;

}

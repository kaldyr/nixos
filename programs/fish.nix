{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [
        ".config/fish"
        ".local/share/fish"
    ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs.fishPlugins; [
            autopair
            fzf-fish
            puffer
            sponge
        ];

        programs.fish = {

            enable = true;

            functions.fish_greeting = "";

            interactiveShellInit = /* fish */ ''
                fish_vi_key_bindings insert
            '';

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
                rev = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
                sha256 = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
            } + "/themes/Catppuccin Frappe.theme";

            desktopEntries.fish = { name = "Fish Shell"; noDisplay = true; };

        };

    };

    programs.fish.enable = true;

}

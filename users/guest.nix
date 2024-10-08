{ inputs, pkgs, sysConfig, ...}: {

    home-manager = {

        extraSpecialArgs = { inherit inputs sysConfig; };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.guest = {

            home = {
                homeDirectory = "/home/guest";
                stateVersion = sysConfig.instalVersion;
                username = "guest";
            };

            programs.fish = {

                enable = true;

                functions.fish_greeting = "";

                interactiveShellInit = /* fish */ ''
                    bind \cl 'clear ; tput cup $(tput lines) ; commandline -f repaint'
                    tput cup $(tput lines) ; commandline -f repaint
                    zellij attach coding && exit
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

            programs.home-manager.enable = true;

            xdg = {

                enable = true;
            
                configFile."fish/themes/Catppuccin Frappe.theme".source = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "fish";
                    rev = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
                    sha256 = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
                } + "/themes/Catppuccin Frappe.theme";

                desktopEntries.fish = { name = "Fish Shell"; noDisplay = true; };

            };

        };

    };

    users = {

        mutableUsers = false;

        users.guest = {

            description = "Guest";
            isNormalUser = true;

            openssh.authorizedKeys.keys = [

            ];

            shell = pkgs.fish;

        };

    };

}

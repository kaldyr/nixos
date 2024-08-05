{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.btop = {

            enable = true;

            settings = {
                color_theme = "catppuccin_frappe.theme";
                log_level = "WARNING";
                proc_tree = true;
                theme_background = false;
                vim_keys = true;
            };

        };

        xdg = {

            configFile."btop/themes/catppuccin_frappe.theme".source = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "btop";
                rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
                sha256 = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
            } + "/themes/catppuccin_frappe.theme";

            desktopEntries.btop = { name = "btop++"; noDisplay = true; };

        };

    };

}

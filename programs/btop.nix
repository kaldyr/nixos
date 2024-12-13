{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.btop.enable = true;

        xdg.configFile."btop/btop.conf".text = /* bash */ ''
            clock_format = ""
            color_theme = "catppuccin_frappe.theme"
            disks_filter = "/ /boot /home /nix"
            log_level = "WARNING"
            proc_tree = True
            theme_background = False
            vim_keys = True
        '';

        xdg.configFile."btop/themes/catppuccin_frappe.theme".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "btop";
            rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
            sha256 = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
        } + "/themes/catppuccin_frappe.theme";

        xdg.desktopEntries.btop = { name = "btop++"; noDisplay = true; };

    };

}

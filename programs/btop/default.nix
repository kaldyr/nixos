{ pkgs, sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.btop.enable = true;

        xdg = {
            configFile."btop/btop.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/btop/config/btop.conf";

            configFile."btop/themes/catppuccin_frappe.theme".source = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "btop";
                rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
                sha256 = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
            } + "/themes/catppuccin_frappe.theme";

            desktopEntries.btop = { name = "btop++"; noDisplay = true; };
        };
    };
}

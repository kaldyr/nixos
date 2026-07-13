{ pkgs, sysConfig, ... }: {
    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.bat.enable = true;

        xdg.configFile."bat/config".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/bat/config/config";

        xdg.configFile."bat/themes/Catppuccin Frappe.tmTheme".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
        } + "/themes/Catppuccin Frappe.tmTheme";
    };
}


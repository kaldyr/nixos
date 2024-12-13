{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.bat.enable = true;

        xdg.configFile."bat/config".text = /* bash */ ''
            --theme='Catppuccin Frappe'
        '';

        xdg.configFile."bat/themes/Catppuccin Frappe.tmTheme".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
            sha256 = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
        } + "/themes/Catppuccin Frappe.tmTheme";

    };

}

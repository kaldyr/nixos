{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = { config, ... }: {

        programs.kitty.enable = true;

        xdg.configFile."kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/kitty/kitty.conf";
        xdg.configFile."kitty/themes/frappe.conf".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "kitty";
            rev = "43098316202b84d6a71f71aaf8360f102f4d3f1a";
            sha256 = "sha256-akRkdq8l2opGIg3HZd+Y4eky6WaHgKFQ5+iJMC1bhnQ=";
        } + "/themes/frappe.conf";

    };

}

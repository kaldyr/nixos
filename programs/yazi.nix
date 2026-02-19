{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            mediainfo
            simple-mtpfs
        ];

        programs.yazi = {

            enable = true;
            enableFishIntegration = true;

            plugins = let

                yazi-plugins = pkgs.fetchFromGitHub {
                    owner = "yazi-rs";
                    repo = "plugins";
                    rev = "d078b01ecbdb0f85f6ea8836a851c6bf72f9f865";
                    sha256 = "sha256-aPe1AntPE76xq0VA/4FtBtRXmj+tfDjdMlQ9B9MkM+U=";
                };

            in {

                "chmod" = "${yazi-plugins}/chmod.yazi";
                "full-border" = "${yazi-plugins}/full-border.yazi";
                "hide-preview" = "${yazi-plugins}/hide-preview.yazi";
                "jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";

                "smart-filter" = "${yazi-plugins}/smart-filter.yazi";

                "starship" = pkgs.fetchFromGitHub {
                    owner = "Rolv-Apneseth";
                    repo = "starship.yazi";
                    rev = "eca186171c5f2011ce62712f95f699308251c749";
                    sha256 = "sha256-xcz2+zepICZ3ji0Hm0SSUBSaEpabWUrIdG7JmxUl/ts=";
                };

            };

        };

        xdg.configFile = {
            "yazi/init.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/init.lua";
            "yazi/keymap.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/keymap.toml";
            "yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/yazi.toml";
        };

    };

}

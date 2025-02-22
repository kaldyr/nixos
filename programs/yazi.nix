{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/state".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            mediainfo
            ouch
            simple-mtpfs
        ];

        programs.yazi = {

            enable = true;
            enableFishIntegration = true;

            plugins = let

                yazi-plugins = pkgs.fetchFromGitHub {
                    owner = "yazi-rs";
                    repo = "plugins";
                    rev = "5186af7984aa8cb0550358aefe751201d7a6b5a8";
                    sha256 = "sha256-Cw5iMljJJkxOzAGjWGIlCa7gnItvBln60laFMf6PSPM=";
                };

            in {

                "chmod" = "${yazi-plugins}/chmod.yazi";
                "full-border" = "${yazi-plugins}/full-border.yazi";
                "hide-preview" = "${yazi-plugins}/hide-preview.yazi";
                "jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";

                "ouch" = pkgs.fetchFromGitHub {
                    owner = "ndtoan96";
                    repo = "ouch.yazi";
                    rev = "v0.4.1";
                    sha256 = "sha256-oUEUGgeVbljQICB43v9DeEM3XWMAKt3Ll11IcLCS/PA=";
                };

                "simple-mtpfs" = pkgs.fetchFromGitHub {
                    owner = "boydaihungst";
                    repo = "simple-mtpfs.yazi";
                    rev = "614a2d295815b430a9e267e00aa212015bc0d36d";
                    sha256 = "sha256-SoO3qAgUPTPBo7kK+gKNITXbHOmzmyx9hUZzIg4P/58=";
                };

                "smart-filter" = "${yazi-plugins}/smart-filter.yazi";

                "starship" = pkgs.fetchFromGitHub {
                    owner = "Rolv-Apneseth";
                    repo = "starship.yazi";
                    rev = "f6939fbdbc3fdfcdc2a80251841e429e0cd5cf3c";
                    sha256 = "sha256-5QQsFozbulgLY/Gl6QuKSOTtygULveoRD49V00e0WOw";
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

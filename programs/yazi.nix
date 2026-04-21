{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [
            glow
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
                    rev = "442d9080da7524c8e58e10c610b832538c87464d";
                    sha256 = "sha256-5WxCUf/Lv3wms7IPgkK0lJuJhIPa1E46obOFASS8eZU=";
                };

            in {

                "chmod" = "${yazi-plugins}/chmod.yazi";
                "full-border" = "${yazi-plugins}/full-border.yazi";
                "hide-preview" = "${yazi-plugins}/hide-preview.yazi";
                "jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";
                "mount" = "${yazi-plugins}/mount.yazi";

                "ouch" = pkgs.fetchFromGitHub {
                    owner = "ndtoan96";
                    repo = "ouch.yazi";
                    rev = "v0.7.0";
                    sha256 = "sha256-1kNqEXPjuXMtYDgRdQNqc8Y0waWHj+I2XXmvk9Sz0g0=";
                };

                "piper" = "${yazi-plugins}/piper.yazi";
                "smart-enter" = "${yazi-plugins}/smart-enter.yazi";
                "smart-filter" = "${yazi-plugins}/smart-filter.yazi";
                "smart-paste" = "${yazi-plugins}/smart-paste.yazi";

                "starship" = pkgs.fetchFromGitHub {
                    owner = "Rolv-Apneseth";
                    repo = "starship.yazi";
                    rev = "a83710153ab5625a64ef98d55e6ddad480a3756f";
                    sha256 = "sha256-CPRVJVunBLwFLCoj+XfoIIwrrwHxqoElbskCXZgFraw=";
                };

            };

            shellWrapperName = "y";

        };

        xdg.configFile = {
            "yazi/init.lua".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/init.lua";
            "yazi/keymap.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/keymap.toml";
            "yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/yazi/yazi.toml";
        };

    };

}

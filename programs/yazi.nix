{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];
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
                    rev = "b12a9ab085a8c2fe2b921e1547ee667b714185f9";
                    sha256 = "sha256-LWN0riaUazQl3llTNNUMktG+7GLAHaG/IxNj1gFhDRE=";
                };

            in {

                "chmod" = "${yazi-plugins}/chmod.yazi";
                "full-border" = "${yazi-plugins}/full-border.yazi";
                "hide-preview" = "${yazi-plugins}/hide-preview.yazi";
                "jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";

                "ouch" = pkgs.fetchFromGitHub {
                    owner = "ndtoan96";
                    repo = "ouch.yazi";
                    rev = "v0.5.0";
                    sha256 = "sha256-p3Xc5+rv3280qwV1H6nrhlkMnK6MWAqv/6Hvf4chtHY=";
                };

                "simple-mtpfs" = pkgs.fetchFromGitHub {
                    owner = "boydaihungst";
                    repo = "simple-mtpfs.yazi";
                    rev = "1e504bebc8c7942c0d92ad4c92fa182d57a325f5";
                    sha256 = "sha256-9o3fXA5Q3Iciuij0WoSRHoobfqiICaRBv02dYneUeig=";
                };

                "smart-filter" = "${yazi-plugins}/smart-filter.yazi";

                "starship" = pkgs.fetchFromGitHub {
                    owner = "Rolv-Apneseth";
                    repo = "starship.yazi";
                    rev = "c0707544f1d526f704dab2da15f379ec90d613c2";
                    sha256 = "sha256-H8j+9jcdcpPFXVO/XQZL3zq1l5f/WiOm4YUxAMduSRs=";
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

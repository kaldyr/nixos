{ lib, pkgs, sysConfig, ... }: {

    # environment.persistence = lib.mkIf sysConfig.homeImpermanence {
    #     "/nix".users.${sysConfig.user}.directories = [
    #     ];
    # };

    home-manager.users.${sysConfig.user} = {

        programs.zsh = {

            enable = true;

            shellAliases = {
                "!!" = "eval \\$history[1]";
                cp = "cp -i";
                df = "duf";
                du = "du -hs";
                ln = "ln -i";
                ls = "g -1 --color basic --dir-first --git --icon --sort .name";
                ll = "ls --long";
                la = "ls --long --almost-all";
                lla = "ls --long --almost-all";
                l = "ls";
                mkdir = "mkdir -pv";
                mv = "mv -i";
                rm = "rm -i";
            };

        };

    };

    programs.zsh.enable = true;

}

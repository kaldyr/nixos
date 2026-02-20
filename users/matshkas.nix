{ config, pkgs, ...}: {

    home-manager.users."matshkas" = {

        home = {
            sessionVariables.EDITOR = "nano";
            sessionVariables.VISUAL = "nano";
        };

        programs.zellij.enableFishIntegration = false;

    };

    sops.secrets.matshkas-password.neededForUsers = true;

    users = {

        mutableUsers = false;

        users."matshkas" = {

            description = "Matshkas";
            extraGroups = [ "wheel" "networkmanager" "video" ];
            hashedPasswordFile = config.sops.secrets.matshkas-password.path;
            isNormalUser = true;

            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWSkGF1Yb4kkxWOUegI2yXFFYKcfsCyWWnu8LwHhImo matt@hofud"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
            ];

            shell = pkgs.fish;

        };

    };

}

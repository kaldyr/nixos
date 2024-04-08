{ config, pkgs, ...}: {

    imports = [ ../home ];

    home-manager.home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    programs.fish.enable = true;
    programs.nano.enable = false;

    sops.secrets.matt-password.neededForUsers = true;

    users = {

        mutableUsers = false;

        users.matt = {

            description = "Matt";
            extraGroups = [ "wheel" "networkmanager" "video" ];
            hashedPasswordFile = config.sops.secrets.matt-password.path;
            isNormalUser = true;

            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvQpANtgx4Zfpeyn9JcQUthOdqkemkrbVF+0fSa8Fbz matt@gram"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWSkGF1Yb4kkxWOUegI2yXFFYKcfsCyWWnu8LwHhImo matt@hofud"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEI16mw0+rV583qqsxv0zjEUfGgcwXczuOYFjWrDYmg matt@magrathea"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
            ];

            shell = pkgs.fish;

        };

    };

}

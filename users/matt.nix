{ config, pkgs, sysConfig, ...}: {

    imports = [ ./default.nix ];

    home-manager.users.${sysConfig.user}.home.sessionVariables.EDITOR = "nvim";
    home-manager.users.${sysConfig.user}.home.sessionVariables.VISUAL = "nvim";

    programs.nano.enable = false;

    sops.secrets.matt-password.neededForUsers = true;

    users = {

        mutableUsers = false;

        users.${sysConfig.user} = {

            description = "Matt";
            extraGroups = [ "wheel" "networkmanager" "video" ];
            hashedPasswordFile = config.sops.secrets.matt-password.path;
            isNormalUser = true;

            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvQpANtgx4Zfpeyn9JcQUthOdqkemkrbVF+0fSa8Fbz matt@gram"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEI16mw0+rV583qqsxv0zjEUfGgcwXczuOYFjWrDYmg matt@magrathea"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2NONOi1+Moj3dj/K2jHlakcTUgmRR5RxqlHzvlrxPF matt@mjolnir"
            ];

            shell = pkgs.fish;

        };

    };

}

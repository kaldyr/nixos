{ pkgs, sysConfig, ...}: {

    home-manager.users.${sysConfig.user}.home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    users = {

        mutableUsers = false;

        users.nixos = {
            description = "NixOS";
            extraGroups = [ "wheel" "networkmanager" "video" ];
            isNormalUser = true;
            shell = pkgs.fish;
        };

    };

    security.sudo.wheelNeedsPassword = false;

}

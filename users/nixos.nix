{ pkgs, ...}: {

    programs.fish.enable = true;

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

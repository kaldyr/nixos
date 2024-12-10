{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            keepassxc
            keepmenu
        ];

    };

}

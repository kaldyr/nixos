{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.programs.zoxide = {

        enable = true;

        enableFishIntegration = true;

    };

}

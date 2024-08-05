{ sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [
        ".local/share/zoxide"
    ];

    home-manager.users.${sysConfig.user}.programs.zoxide = {

        enable = true;

        enableFishIntegration = true;

    };

}

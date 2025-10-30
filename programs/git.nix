{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.programs.git = {

        enable = true;
        settings.user.email = "kaldyr@gmail.com";
        settings.user.name = "kaldyr";

    };

}

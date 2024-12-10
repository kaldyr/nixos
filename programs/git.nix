{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.programs.git = {

        enable = true;

        userEmail = "kaldyr@gmail.com";
        userName = "kaldyr";

    };

}

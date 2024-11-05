{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user}.programs.eza = {

        enable = true;

        enableFishIntegration = true;
        enableNushellIntegration = true;

        extraOptions = [
            "-1"
            "--color=always"
            "-g"
            "--group-directories-first"
        ];

        git = true;

        icons = "auto";

    };

}

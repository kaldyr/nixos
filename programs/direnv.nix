{ sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [
        ".local/share/direnv"
    ];

    home-manager.users.${sysConfig.user} = {

        home.sessionVariables.DIRENV_LOG_FORMAT = "";
        home.sessionVariables.DIRENV_WARN_TIMEOUT = "0";

        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;

    };

}

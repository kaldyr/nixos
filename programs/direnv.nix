{ sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [
        ".local/share/direnv"
    ];

    home-manager.users.${sysConfig.user} = {
        
        home.sessionVariables.DIRENV_LOG_FORMAT = "";

        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;

    };

}

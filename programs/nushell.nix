{ sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.files = [
        ".config/nushell/history.sqlite3"
        ".config/nushell/history.sqlite3-shm"
        ".config/nushell/history.sqlite3-wal"
    ];

    home-manager.users.${sysConfig.user} = {

        programs.nushell.enable = true;

    };

}

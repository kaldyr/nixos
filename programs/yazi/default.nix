{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [ ".local/state/yazi" ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.file.".local/share/yazi/sshfs.list".text = ''
            espresso
            hofud
            magrathea
            mjolnir
        '';

        home.packages = with pkgs; [
            glow
            mediainfo
            ouch
            sshfs
            yazi
        ];

        xdg.configFile."yazi".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/yazi/config";

    };

}

{ lib, pkgs, sysConfig, ... }: {

    # environment.persistence = lib.mkIf sysConfig.homeImpermanence {
    #     "/nix".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];
    # };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            (retroarch.withCores (
                cores: with cores; [
                    genesis-plus-gx
                    melonds
                    nestopia
                    snes9x
                    vba-m
                ]
            ))
        ];

        # xdg.configFile."Nextcloud/nextcloud.cfg".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/Nextcloud/${sysConfig.hostname}.cfg";

    };

}

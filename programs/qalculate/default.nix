{ lib, sysConfig, ... }: {
    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".local/state/qalculate"
        ];
    };

    home-manager.users.${sysConfig.user} = { config, ... }: {
        programs.qalculate.enable = true;
        xdg.configFile."qalculate".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/qalculate/config";
    };
}

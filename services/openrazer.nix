{ sysConfig, ... }: {

    hardware.openrazer.enable = true;
    hardware.openrazer.devicesOffOnScreensaver = true;

    home-manager.users.${sysConfig.user} = { config, ... }: {
        xdg.configFile."openrazer/persistence.conf".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/dotfiles/openrazer/persistence.conf";
    };

    users.users.${sysConfig.user}.extraGroups = [ "openrazer" ];

}

{ sysConfig, ... }: {

    hardware.openrazer = {

        enable = true;

        devicesOffOnScreensaver = true;
        users = [ "${sysConfig.user}" ];

    };

    users.users.${sysConfig.user}.extraGroups = [ "openrazer" ];

}

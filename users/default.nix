{ inputs, sysConfig, ...}: {

    home-manager = {

        extraSpecialArgs = { inherit inputs sysConfig; };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${sysConfig.user} = {

            home = {
                homeDirectory = "/home/${sysConfig.user}";
                stateVersion = sysConfig.instalVersion;
                username = sysConfig.user;
            };

            programs.home-manager.enable = true;

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";

            xdg.enable = true;

        };

    };

}

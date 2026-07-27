{ lib, pkgs, sysConfig, ... }: {
    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/lutris"
            ".cache/umu"
            ".config/lutris"
            ".local/share/lutris"
            ".local/share/umu"
            ".wine"
        ];
    };

    home-manager.users.${sysConfig.user} = {
        home.packages = with pkgs; [
            mesa-demos
            umu-launcher
            wine
        ];

        home.sessionVariables."LD_PRELOAD" = "${pkgs.gamemode.lib}/lib/libgamemode.so.0";

        programs.lutris = {
            enable = true;

            extraPackages = with pkgs; [
                gamemode
                libGL
                libGLU
                mesa
                mesa-demos
                protobuf
                proton-ge-bin
                umu-launcher
                vulkan-tools
                wineWow64Packages.full
                winetricks
            ];

            winePackages = with pkgs; [ wineWow64Packages.full ];
        };
    };
}

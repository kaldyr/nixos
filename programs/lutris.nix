{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".cache/lutris"
            ".config/lutris"
            ".local/share/lutris"
            ".wine"
        ];
    };

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ wine ];

        programs.lutris = {
            enable = true;
            extraPackages = with pkgs; [
                gamemode
                protobuf
                proton-ge-bin
                winetricks
                wineWow64Packages.full
            ];
            defaultWinePackage = pkgs.proton-ge-bin;
            winePackages = with pkgs; [ wineWow64Packages.full ];
        };

    };

}

{ lib, pkgs, sysConfig, ... }:
let
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
        "${pkgs.quickshell}/lib/qt-6/qml"
        "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
        "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
        "."
    ];
in
{

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.packages = with pkgs; [ quickshell ];

        home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

        systemd.user.services.quickshell = {

            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                Description = "Quickshell";
                PartOf = [ "tray.target" "graphical-session.target" ];
                After = "graphical-session.target";
            };

            Service = {
                Environment = "PATH=/run/wrappers/bin QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
                ExecStart = lib.getExe pkgs.quickshell;
                Restart = "on-failure";
            };
        };

        xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/quickshell/config";

    };

}

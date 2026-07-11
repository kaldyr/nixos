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

    environment.systemPackages = with pkgs; [
        quickshell
        upower
    ];

    home-manager.users.${sysConfig.user} = { config, ... }: {

        home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

        systemd.user.services.quickshell = {

            Install.WantedBy = [ "graphical-session.target" ];

            Unit = {
                Description = "Quickshell";
                PartOf = [ "tray.target" "graphical-session.target" ];
                After = "graphical-session.target";
            };

            Service = {
                Environment = [
                    "PATH=/run/wrappers/bin:/run/current-system/sw/bin"
                    "QSG_RHI_BACKEND=vulkan"
                ];
                ExecStart = lib.getExe pkgs.quickshell;
                PassEnvironment = [
                    "DBUS_SESSION_BUS_ADDRESS"
                    "QML2_IMPORT_PATH"
                ];
                Restart = "on-failure";
            };
        };

        xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/quickshell/config";

    };

}

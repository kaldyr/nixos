{
  lib,
  pkgs,
  sysConfig,
  ...
}:
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
    home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;
    programs.quickshell.enable = true;
    programs.quickshell.systemd.enable = true;

    xdg.configFile =
      let
        src = config.lib.file.mkOutOfStoreSymlink;
        root = "/nix/config/programs/quickshell/config";
      in
      {
        "quickshell/shell.qml".source = src "${root}/shell.qml";
        "quickshell/ColorSchemes".source = src "${root}/ColorSchemes";
        "quickshell/Components".source = src "${root}/Components";
        "quickshell/settings.json".source = src "${root}/${sysConfig.hostname}.json";
      };
  };
}

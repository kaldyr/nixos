{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [ openscad ];

  home-manager.users.${sysConfig.user} = { config, ... }: {
    xdg.configFile."OpenSCAD/color-schemes/editor".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/openscad/config";
  };
}

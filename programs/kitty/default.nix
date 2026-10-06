{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [ kitty ];

  home-manager.users.${sysConfig.user} = { config, ... }: {
    xdg.configFile."kitty".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/kitty/config";
  };
}

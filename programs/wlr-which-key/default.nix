{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [ wlr-which-key ];

  home-manager.users.${sysConfig.user} = { config, ... }: {
    xdg.configFile."wlr-which-key/config.yaml".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/wlr-which-key/config/config.yaml";
  };
}

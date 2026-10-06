{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [ lazygit ];

  home-manager.users.${sysConfig.user} = { config, ... }: {
    xdg.configFile."lazygit/config.yml".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/lazygit/config/config.yml";
  };
}

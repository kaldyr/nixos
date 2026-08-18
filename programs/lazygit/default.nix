{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = { config, ... }: {
    home.packages = with pkgs; [ lazygit ];

    xdg.configFile."lazygit/config.yml".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/lazygit/config/config.yml";
  };
}

{
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = { config, ... }: {
    programs.fuzzel.enable = true;

    xdg.configFile."fuzzel/fuzzel.ini".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/fuzzel/config/fuzzel.ini";
  };
}

{
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = { config, ... }: {
    services.easyeffects.enable = true;

    home.file = {
      ".local/share/easyeffects/input".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/easyeffects/config/input";

      ".local/share/easyeffects/output".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/easyeffects/config/output";

      ".local/share/easyeffects/autoload".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/easyeffects/config/${sysConfig.hostname}";
    };
  };
}

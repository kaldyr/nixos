{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    dotool
    keepmenu
  ];

  home-manager.users.${sysConfig.user} = { config, ... }: {
    programs.keepassxc.enable = true;

    xdg.configFile."keepmenu/config.ini".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/keepass/config/config.ini";
  };
}

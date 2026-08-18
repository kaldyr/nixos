{
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = {
    programs.zoxide.enable = true;
    programs.zoxide.enableFishIntegration = true;
  };
}

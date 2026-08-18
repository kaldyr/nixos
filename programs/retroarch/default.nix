{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = {
    home.packages = with pkgs; [
      (retroarch.withCores (
        cores: with cores; [
          genesis-plus-gx
          melonds
          nestopia
          snes9x
          vba-m
        ]
      ))
    ];
  };
}

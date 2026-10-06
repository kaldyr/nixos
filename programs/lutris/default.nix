{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mesa-demos
    umu-launcher
    wine
  ];

  home-manager.users.${sysConfig.user} = {
    home.sessionVariables."LD_PRELOAD" = "${pkgs.gamemode.lib}/lib/libgamemode.so.0";

    programs.lutris = {
      enable = true;

      extraPackages = with pkgs; [
        gamemode
        libGL
        libGLU
        mesa
        mesa-demos
        protobuf
        proton-ge-bin
        umu-launcher
        vulkan-tools
        wineWow64Packages.full
        winetricks
      ];

      winePackages = with pkgs; [ wineWow64Packages.full ];
    };
  };
}

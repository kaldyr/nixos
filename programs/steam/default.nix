{
  pkgs,
  ...
}:
{
  hardware.graphics.extraPackages32 = with pkgs; [ pkgsi686Linux.libva ];

  programs = {
    gamemode.enable = true;

    steam = {
      enable = true;

      package = pkgs.steam.override {
        extraProfile = ''
          export XCURSOR_PATH="$HOME/.local/share/steam-cursors''${XCURSOR_PATH:+:$XCURSOR_PATH}"
          '';
      };

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };

  services.pipewire.alsa.support32Bit = true;
}

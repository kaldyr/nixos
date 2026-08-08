{ inputs, ... }: {
  additions = final: _prev: import ./pkgs final.pkgs;

  modifications = final: prev: {
    # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.stdenv.hostPlatform.system}.PACKAGE;
    discord =
      (prev.discord.override {
        withVencord = true;
      }).overrideAttrs
        (prevAttrs: {
          desktopItem = prevAttrs.desktopItem.override (prevDesktopAttrs: {
            exec = "env ELECTRON_OZONE_PLATFORM_HINT= ${prevDesktopAttrs.exec} --enable-blink-features=MiddleClickAutoscroll --enable-features=WebRTCPipeWireCapturer";
          });
        });

    helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;
    yazi = inputs.yazi.packages.${prev.stdenv.hostPlatform.system}.yazi;
  };
}

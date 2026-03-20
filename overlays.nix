{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.stdenv.hostPlatform.system}.PACKAGE;

        discord = (prev.discord.override {
            withOpenASAR = true;
            withVencord = true;
        }).overrideAttrs (prevAttrs: {
            desktopItem = prevAttrs.desktopItem.override (prevDesktopAttrs: {
                exec = "env NIXOS_OZONE_WL=1 ELECTRON_PLATFORM_HINT=wayland ${prevDesktopAttrs.exec} --enable-blink-features=MiddleClickAutoscroll --enable-features=WebRTCPipeWireCapturer";
            });
        });

        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.stdenv.hostPlatform.system}.exiftool;
        helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;
        floorp-bin = inputs.nixpkgs-floorp.legacyPackages.${prev.stdenv.hostPlatform.system}.floorp-bin;
        yt-dlp = inputs.nixpkgs-yt-dlp.legacyPackages.${prev.stdenv.hostPlatform.system}.yt-dlp;
        zmx = inputs.zmx.packages.${prev.stdenv.hostPlatform.system}.default;

    };

}

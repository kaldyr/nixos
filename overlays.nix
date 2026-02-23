{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.system}.PACKAGE;

        discord = (prev.discord.override {
            withOpenASAR = true;
            withVencord = true;
        }).overrideAttrs (prevAttrs: {
            desktopItem = prevAttrs.desktopItem.override (prevDesktopAttrs: {
                exec = "env NIXOS_OZONE_WL=1 ELECTRON_PLATFORM_HINT=wayland ${prevDesktopAttrs.exec} --enable-blink-features=MiddleClickAutoscroll --enable-features=WebRTCPipeWireCapturer";
            });
        });

        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.stdenv.hostPlatform.system}.exiftool;
        floorp-bin = inputs.nixpkgs-floorp.legacyPackages.${prev.stdenv.hostPlatform.system}.floorp-bin;
        helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;

    };

}

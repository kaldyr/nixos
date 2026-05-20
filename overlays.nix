{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.stdenv.hostPlatform.system}.PACKAGE;

        discord = (prev.discord.override {
            # withOpenASAR = true;
            withVencord = true;
        }).overrideAttrs (prevAttrs: {
            desktopItem = prevAttrs.desktopItem.override (prevDesktopAttrs: {
                exec = "env NIXOS_OZONE_WL=1 ELECTRON_PLATFORM_HINT=wayland ${prevDesktopAttrs.exec} --enable-blink-features=MiddleClickAutoscroll --enable-features=WebRTCPipeWireCapturer";
            });
        });

        floorp-bin = inputs.nixpkgs-floorp.legacyPackages.${prev.stdenv.hostPlatform.system}.floorp-bin;
        helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;

        # Hyprland flake
        hyprland = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.hyprland;
        xdg-desktop-portal-hyprland = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

        openldap = prev.openldap.overrideAttrs {
            doCheck = !prev.stdenv.hostPlatform.isi686;
        };

        quickshell = inputs.quickshell.packages.${prev.stdenv.hostPlatform.system}.default;
        yazi = inputs.yazi.packages.${prev.stdenv.hostPlatform.system}.yazi;
        zmx = inputs.zmx.packages.${prev.stdenv.hostPlatform.system}.default;

    };

}

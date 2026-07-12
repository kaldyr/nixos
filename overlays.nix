{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.stdenv.hostPlatform.system}.PACKAGE;

        discord = (prev.discord.override {
            # withOpenASAR = true;
            withVencord = true;  # Disabled 2026-06-30 when sections of interface stopped working
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

        yazi = inputs.yazi.packages.${prev.stdenv.hostPlatform.system}.yazi;

    };

}

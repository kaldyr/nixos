{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

    modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.system}.PACKAGE;

        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.system}.exiftool;
        floorp-bin = inputs.nixpkgs-floorp.legacyPackages.${prev.system}.floorp-bin;
        # hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
        # neovim = inputs.neovim.packages.${prev.system}.neovim;
        helium = inputs.helium.packages.${prev.system}.default;

        discord = (prev.discord.override {
            withOpenASAR = true;
            withVencord = true;
        }).overrideAttrs (prevAttrs: {
            desktopItem = prevAttrs.desktopItem.override (prevDesktopAttrs: {
                exec = "env NIXOS_OZONE_WL=1 ELECTRON_PLATFORM_HINT=wayland ${prevDesktopAttrs.exec} --enable-blink-features=MiddleClickAutoscroll --enable-features=WebRTCPipeWireCapturer";
            });
        });

    };

}

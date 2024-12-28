{ inputs, ... }: {

    additions = final: _prev: import ./pkgs final.pkgs;

        modifications = final: prev: {

        # PACKAGE = inputs.NIXPKGS-VERSION.legacyPackages.${prev.system}.PACKAGE;

        exiftool_12-70 = inputs.nixpkgs-exiftool.legacyPackages.${prev.system}.exiftool;
        hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
        neovim = inputs.neovim.packages.${prev.system}.neovim;
        # yazi = inputs.yazi.packages.${prev.system}.yazi;
        wezterm = inputs.wezterm.packages.${prev.system}.default;
        zellijPlugins.zjstatus = inputs.zjstatus.packages.${prev.system}.default;

    };

}

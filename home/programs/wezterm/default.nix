{
# { inputs, pkgs, ... }: {

    programs.wezterm.enable = true;
    # programs.wezterm.package = inputs.wezterm.packages.${pkgs.system}.default;

    xdg.configFile."wezterm/wezterm.lua".source = ./config/wezterm.lua;

}

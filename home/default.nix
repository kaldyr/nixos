{ pkgs, ... }: {

    imports = [
        ./modules/bat.nix
        ./modules/btop.nix
        ./modules/eza.nix
        ./modules/fish.nix
        ./modules/fzf.nix
        ./modules/git.nix
        ./modules/lazygit.nix
        ./modules/neovim.nix
        ./modules/starship.nix
        ./modules/yazi.nix
        ./modules/zellij.nix
        ./modules/zoxide.nix
    ];

    home.packages = with pkgs; [
        age
        bc
        duf
        fd
        gdu
        jq
        ripgrep
        sops
        ssh-to-age
    ];

    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    xdg.enable = true;

}

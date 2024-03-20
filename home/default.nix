{ pkgs, ... }: {

    imports = [
        ./programs/bat.nix
        ./programs/btop.nix
        ./programs/eza.nix
        ./programs/fish.nix
        ./programs/fzf.nix
        ./programs/git.nix
        ./programs/lazygit.nix
        ./programs/neovim.nix
        ./programs/starship.nix
        ./programs/yazi.nix
        ./programs/zellij.nix
        ./programs/zoxide.nix
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

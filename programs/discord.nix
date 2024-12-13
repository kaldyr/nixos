{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            ".config/discord"
            ".config/Vencord"
        ];
    };

    environment.systemPackages = with pkgs; [
        libevdev
        xdotool
    ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            (discord.override { withVencord = true; })
            wayland-push-to-talk-fix
        ];

        xdg.configFile."Vencord/themes/frappe.theme.css".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "discord";
            rev = "16b1e5156583ee376ded4fa602842fa540826bbc";
            sha256 = "sha256-ECVHRuHbe3dvwrOsi6JAllJ37xb18HaUPxXoysyPP70=";
        } + "/themes/frappe.theme.css";

    };

}

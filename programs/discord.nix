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
            discord
            wayland-push-to-talk-fix
        ];

        xdg.configFile."Vencord/themes/frappe.theme.css".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "discord";
            rev = "f235754322320211a8646d963466fac402e5c297";
            sha256 = "sha256-7v1Hu6QofOyFOGnHeqHFK0JsxUxdJ9uTjI7nM7mdTsg=";
        } + "/themes/frappe.theme.css";

    };

}

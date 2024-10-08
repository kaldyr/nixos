{ pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.directories = [
        ".config/BetterDiscord"
        ".config/discord"
    ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ discord ];

        xdg.configFile."BetterDiscord/themes/frappe.theme.css".source = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "discord";
            rev = "807261856fb5e481a44162917b6d07ad0b587435";
            sha256 = "sha256-m7KevE6kCBAbO2ss+ZJo/0Kp05Ii9FLwtCFRrV+Z3rM=";
        } + "/themes/frappe.theme.css";

    };

}

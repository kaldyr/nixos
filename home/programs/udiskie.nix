{ pkgs, ... }: {

    home.packages = with pkgs; [
        udiskie
        udisks
    ];

    services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
    };

}

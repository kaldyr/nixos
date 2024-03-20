{ pkgs, ... }: {

    home.packages = with pkgs; [ feh ];

    xdg.mimeApps.associations.added."application/image" = [ "feh.desktop" ];

}

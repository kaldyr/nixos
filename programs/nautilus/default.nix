{ pkgs, sysConfig, ... }: {
  environment.systemPackages = with pkgs; [ nautilus ];

  home-manager.users.${sysConfig.user} = {
    dconf.settings = {
      "org/gtk/settings/file-chooser".sort-directories-first = true;

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "icon-view";
        search-view = "list-view";
      };

      "org/gnome/nautilus/compression" = {
        default-compression-format = "zip";
      };

      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "medium";
      };

    };

    xdg.mimeApps.associations.added."inode/directory" = [ "nautilus.desktop" ];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  services = {
    gnome.sushi.enable = true;
    gvfs.enable = true;
  };
}

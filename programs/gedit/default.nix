{ pkgs, sysConfig, ... }: {
  home-manager.users.${sysConfig.user} = { config, ... }: {
    dconf.settings."org/gnome/gedit/preferences/editor" = {
      auto-indent = true;
      bracket-matching = true;
      editor-font = "Maple Mono NF 12";
      insert-spaces = true;
      scheme = "catppuccin-frappe";
      tabs-size = 4;
      use-default-font = false;
    };

    home.file.".local/share/libgedit-gtksourceview-300/styles/catppuccin-frappe.xml".source =
      config.lib.file.mkOutOfStoreSymlink
        "/nix/config/programs/gedit/config/catppuccin-frappe.xml";

    home.packages = with pkgs; [ gedit ];

    xdg.mimeApps.associations.added."text/plain" = [ "nvim.desktop" ];
  };
}

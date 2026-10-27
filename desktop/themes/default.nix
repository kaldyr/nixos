{
  lib,
  pkgs,
  sysConfig,
  ...
}:
let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "sapphire" ];
    size = "standard";
    variant = "frappe";
  };

  catppuccinKvantum = pkgs.catppuccin-kvantum.override {
    accent = "sapphire";
    variant = "frappe";
  };

  catppuccinKvantumLight = pkgs.catppuccin-kvantum.override {
    accent = "sapphire";
    variant = "latte";
  };

  catppuccinFolders = pkgs.catppuccin-papirus-folders.override {
    accent = "sapphire";
    flavor = "frappe";
  };

  colorschemes = {
    catppuccin-frappe = {
      name = "Catppuccin Frappé";
      mode = "dark";

      gtk = {
        name = "catppuccin-frappe-sapphire-standard";
        path = "${catppuccinGtk}/share/themes/catppuccin-frappe-sapphire-standard";
      };

      kvantum = {
        name = "catppuccin-frappe-sapphire";
        path = "${catppuccinKvantum}/share/Kvantum/catppuccin-frappe-sapphire";
      };
    };

    adwaita-light = {
      name = "Adwaita Light";
      mode = "light";

      gtk = {
        name = "Adwaita";
        path = null;
      };

      kvantum = {
        name = "catppuccin-latte-sapphire";
        path = "${catppuccinKvantumLight}/share/Kvantum/catppuccin-latte-sapphire";
      };
    };
  };

  iconThemes = {
    catppuccin-papirus-frappe-sapphire = {
      name = "Catppuccin Papirus Frappé Sapphire";
      gtkName = "Papirus-Dark";
      path = "${catppuccinFolders}/share/icons";
    };

    papirus-light = {
      name = "Papirus Light";
      gtkName = "Papirus-Light";
      path = "${catppuccinFolders}/share/icons";
    };
  };

  cursorThemes = {
    catppuccin-frappe-sapphire = {
      name = "Catppuccin Frappé Sapphire";
      theme = "catppuccin-frappe-sapphire-cursors";
      path = "${pkgs.catppuccin-cursors.frappeSapphire}/share/icons";
    };

    catppuccin-latte-sapphire = {
      name = "Catppuccin Latte Sapphire";
      theme = "catppuccin-latte-sapphire-cursors";
      path = "${pkgs.catppuccin-cursors.latteSapphire}/share/icons";
    };
  };

  schemaDir = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/"
    + "gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}"
    + "/glib-2.0/schemas";

  applyTheme = pkgs.writeShellScriptBin "apply-theme" ''
    export GSETTINGS_SCHEMA_DIR="${schemaDir}"
    exec ${pkgs.python3}/bin/python3 /nix/config/desktop/scripts/apply-theme.py "$@"
  '';
in
{
  environment = {
    etc."desktop-themes.json".source = pkgs.writeText "desktop-themes.json" (
      builtins.toJSON {
        inherit colorschemes iconThemes cursorThemes;
      }
    );

    systemPackages = with pkgs; [
      # Theme helpers glib
      applyTheme
      glib
      gsettings-desktop-schemas
      python3

      # Application Themes
      catppuccinGtk
      catppuccinKvantum
      gnome-themes-extra

      # Cursor Themes
      catppuccin-cursors.frappeSapphire
      catppuccin-cursors.latteSapphire

      # Icon Themes
      catppuccinFolders
    ];
  };

  home-manager.users.${sysConfig.user} = {
    home = {
      file = lib.mapAttrs' (
        _: cursor:
        lib.nameValuePair ".local/share/steam-cursors/${cursor.theme}" {
          source = "${cursor.path}/${cursor.theme}";
        }
      ) cursorThemes;

      sessionVariables = {
        XCURSOR_THEME = "catppuccin-frappe-sapphire-cursors";
        XCURSOR_SIZE = "24";
        HYPRCURSOR_THEME = "catppuccin-frappe-sapphire-cursors";
        HYPRCURSOR_SIZE = "24";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = lib.mapAttrs' (
      _: colorscheme:
      lib.nameValuePair "Kvantum/${colorscheme.kvantum.name}" {
        source = colorscheme.kvantum.path;
      }
    ) (lib.filterAttrs (_: cs: cs.kvantum != null) colorschemes);
  };
}

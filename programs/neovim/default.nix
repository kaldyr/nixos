{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user} = { config, ... }: {
    home.file.".local/share/nvim/grammars".source = pkgs.symlinkJoin {
      name = "nvim-treesitter-grammars";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };

    home.packages = with pkgs; [
      neovim
      # System utilities
      fd
      fzf
      gcc
      git
      gnumake
      ripgrep
      # Language servers
      emmet-ls
      fish-lsp
      gopls
      htmx-lsp
      kdePackages.qtdeclarative
      lua-language-server
      marksman
      nixd
      ols
      python313Packages.python-lsp-server
      taplo
      vscode-langservers-extracted
      yaml-language-server
      # Formatters
      gofumpt
      nixfmt
      prettier
      ruff
      shfmt
      stylua
      # Extras
      python312Packages.pylatexenc
    ];

    xdg = {
      configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/neovim/config/";

      desktopEntries.nvim = {
        name = "Neovim Wrapper";
        noDisplay = true;
      };

      mimeApps.associations.added."text/plain" = [ "nvim.desktop" ];
    };
  };
}

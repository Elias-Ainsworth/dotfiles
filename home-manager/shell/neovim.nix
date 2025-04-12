{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (config.custom.fonts) monospace weeb;
  inherit (config.custom.terminal) opacity;
  inherit (config.custom.colorscheme)
    theme
    transparent
    variant
    ;
  customNeovim = inputs.thornevim.packages.${pkgs.system}.default.override {
    colorscheme = theme;
    variant = variant;
    transparent = transparent;
  };
  nvim-direnv = pkgs.writeShellApplication {
    name = "nvim-direnv";
    runtimeInputs = [
      config.programs.direnv.package
      customNeovim
    ];
    text = # sh
      ''
        if ! direnv exec "$(dirname "$1")" nvim "$@"; then
            nvim "$@"
        fi
      '';
  };
in
{
  home = {
    packages = [
      customNeovim
      nvim-direnv
    ];

    shellAliases = {
      nano = "nvim";
      neovim = "nvim";
      v = "nvim";
      vv = "neovide";
    };
  };

  programs.neovide = {
    enable = true;
    settings = {
      fork = true;
      frame = "full";
      idle = true;
      show-border = true;
      maximized = false;
      neovim-bin = "${customNeovim}/bin/nvim";
      no-multigrid = true;
      transparency = 0.8;
      srgb = false;
      tabs = true;
      theme = "dark";
      title-hidden = true;
      vsync = true;
      wsl = false;
      font = {
        normal = [
          monospace
          weeb
        ];
        size = 12.0;
      };
      box-drawing = {
        mode = "font-glyph";
      };
    };
  };

  xdg = {
    desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      icon = ./nvf.svg;
      terminal = true;
      # load direnv before opening nvim
      exec = ''${getExe nvim-direnv} "%F"'';
    };

    mimeApps = {
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
      };
      associations.added = {
        "text/csv" = "nvim.desktop";
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".cache/nvf"
      ".local/share/nvf" # data directory
      ".local/state/nvf" # persistent session info
      ".local/share/nvim" # data directory
      ".local/state/nvim" # persistent session info
      ".supermaven"
      ".local/share/supermaven"
    ];
  };
}

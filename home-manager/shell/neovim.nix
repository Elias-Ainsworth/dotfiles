{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (config.custom.colorscheme)
    theme
    transparent
    variant
    ;
  customNeovim = inputs.thornevim.packages.${pkgs.system}.default.override {
    colorscheme = theme;
    inherit variant;
    inherit transparent;
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
        "text/markdown" = "nvim.desktop";
        "text/x-nix" = "nvim.desktop";
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

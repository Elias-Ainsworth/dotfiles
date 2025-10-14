{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe hiPrio;
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
      pkgs.direnv
      customNeovim
    ];
    text = # sh
      ''
        if ! direnv exec "$(dirname "$1")" nvim "$@"; then
            nvim "$@"
        fi
      '';
  };
  nvim-desktop-entry = pkgs.makeDesktopItem {
    name = "Neovim";
    desktopName = "Neovim";
    genericName = "Text Editor";
    icon = "nvim";
    terminal = true;
    # load direnv before opening nvim
    exec = ''${getExe nvim-direnv} "%F"'';
  };
in
{
  environment = {
    shellAliases = {
      nano = "nvim";
      neovim = "nvim";
      v = "nvim";
      vv = "neovide";
    };

    systemPackages = [
      customNeovim
      nvim-direnv
      (hiPrio nvim-desktop-entry)
    ];
  };

  xdg = {
    mime = {
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/x-nix" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
      };
      addedAssociations = {
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

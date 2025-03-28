{
  pkgs,
  inputs,
  colorscheme ? "catppuccin",
  maxi ? false,
  transparency ? false,
  dots ? null,
  outputs ? null,
}:
let
  neovimConfig = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ (import ../config) ];
    extraSpecialArgs = {
      # Inputs is seemingly reserved, though the docs don't show it
      inputs' = inputs;
      inherit
        colorscheme
        maxi
        transparency
        dots
        outputs
        ;
    };
  };
in
# Explicitly return the neovim package
neovimConfig.neovim

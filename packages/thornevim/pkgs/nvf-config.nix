{
  inputs,
  pkgs,

  banner ? "eepy",
  colorscheme ? "catppuccin",
  dots ? null,
  maxi ? false,
  outputs ? null,
  transparent ? false,
  variant ? "mocha",
}:
let
  neovimConfig = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [ (import ../config) ];
    extraSpecialArgs = {
      # Inputs is seemingly reserved, though the docs don't show it
      inputs' = inputs;
      inherit
        banner
        colorscheme
        dots
        maxi
        outputs
        transparent
        variant
        ;
    };
  };
in

# Explicitly return the neovim package
neovimConfig.neovim

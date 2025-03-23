{ config, lib, ... }:
let
  inherit (config.custom) colorscheme;
  inherit (lib)
    mkEnableOption
    mkIf
    optionals
    concatStringsSep
    ;
in
{
  options.custom = {
    helix.enable = mkEnableOption "helix";
  };

  config = mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = concatStringsSep "" (
          optionals (colorscheme.theme == "catppuccin") [
            "${colorscheme.theme}_${colorscheme.variant}"
          ]
          ++ optionals (colorscheme.theme == "kanagawa") [ "${colorscheme.theme}-${colorscheme.variant}" ]
        );
      };
    };
  };
}

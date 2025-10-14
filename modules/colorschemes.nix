{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (types)
    str
    bool
    ;
in
{
  options.custom = {
    colorscheme = {
      theme = mkOption {
        type = str;
        default = "oxocarbon";
        description = "System colorscheme";
      };
      transparent = mkOption {
        type = bool;
        default = false;
        description = "Whether to enable transparency";
      };
      variant = mkOption {
        type = str;
        default = "dark";
        description = "System colorscheme variant";
      };
    };
  };
}

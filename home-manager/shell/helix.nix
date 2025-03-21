{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.custom = {
    helix.enable = mkEnableOption "helix";
  };

  config = mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        # theme = "catppuccin_mocha";
        theme = "kanagawa_dragon";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.custom = {
    game-dev.enable = mkEnableOption "game-dev";
  };

  config = mkIf config.custom.game-dev.enable {
    home.packages = with pkgs; [
      godot
    ];

    # custom.persist = {
    #   home.directories = [
    #   ];
    # };
  };
}

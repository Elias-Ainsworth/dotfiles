{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.custom = {
    gaming.enable = mkEnableOption "Gaming on Nix";
  };

  config = mkIf config.custom.gaming.enable {
    home.packages = with pkgs; [
      heroic
      steam-run
      protonup-qt
      wineWowPackages.waylandFull
    ];
    custom.persist = {
      home.directories = [
        "Games"
        ".config/heroic"
      ];
    };
  };
}

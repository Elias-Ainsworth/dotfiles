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
    study.enable = mkEnableOption "study";
  };

  config = mkIf config.custom.study.enable {
    home.packages = with pkgs; [
      anki
      bibletime
      kjv
      pom
    ];

    custom.persist = {
      home.directories = [
        ".bibletime/"
        ".sword/"
        ".local/share/Anki2"
      ];
    };
  };
}

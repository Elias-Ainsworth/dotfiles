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
      bibletime
      kjv
      lowfi
      porsmo
    ];

    custom.persist = {
      home.directories = [
        ".bibletime/"
        ".sword/"
      ];
    };
  };
}

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
    programs.study.enable = mkEnableOption "study";
  };

  config = mkIf config.custom.programs.study.enable {
    environment.systemPackages = with pkgs; [
      # bibletime
      kjv
      lowfi
      porsmo
    ];

    custom.persist = {
      home.directories = [
        # ".bibletime/"
        # ".sword/"
      ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    study.enable = mkEnableOption "study";
  };

  config = lib.mkIf config.custom.study.enable {
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

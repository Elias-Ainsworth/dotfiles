{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    music.enable = mkEnableOption "Music";
  };
  config = lib.mkIf config.custom.music.enable {
    home.packages = with pkgs; [ music-player ];

    custom.persist = {
      home.directories = [
        ".config/music-player"
        "Music"
      ];
    };
  };

}

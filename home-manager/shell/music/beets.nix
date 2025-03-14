{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  inherit (pkgs) beetsPackages;
in
{
  config = mkIf config.custom.beets.enable {
    home.packages = [ beetsPackages.copyartifacts ];
    programs.beets = {
      enable = true;
      # package = beets-unstable;
      settings = {
        directory = "${config.xdg.userDirs.music}";
        library = "${config.xdg.configHome}/beets/library.db";
        import = {
          incremental = true;
          quiet = true;
          move = true;
          log = "${config.xdg.configHome}/beets/import.log";
        };
        paths = {
          default = "$albumartist/$album%aunique{}/$disc-$track $title";
          singleton = "Non-Album/$artist/$title";
          comp = "Compilations/$album/$track $title";
        };
        plugins = [
          "badfiles"
          "chroma"
          "copyartifacts"
          "duplicates"
          "edit"
          "embedart"
          "fetchart"
          # "fileinfo"
          "fromfilename"
          "lastgenre"
          "lyrics"
          "mbsubmit"
          "mbsync"
          "missing"
          "scrub"
          "replaygain"
          "rewrite"
        ];
        fetchart = {
          auto = true;
          minwidth = 500;
          sources = "*";
        };
        lastgenre = {
          auto = true;
          source = "track";
          whitelist = true;
        };
        lyrics = {
          auto = true;
          sources = "*";
          synced = true;
        };
        replaygain = {
          auto = true;
          backend = "ffmpeg";
        };
      };
    };
  };
}

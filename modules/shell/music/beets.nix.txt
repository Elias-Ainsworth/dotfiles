{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.xdg.userDirs) music;
  inherit (lib)
    mkIf
    ;
  inherit (pkgs)
    beets
    beetsPackages
    ffmpeg
    writeShellApplication
    ;
  extractLyrics = writeShellApplication {
    name = "extract-lyrics";
    runtimeInputs = [
      ffmpeg
    ];
    text =
      # bash
      ''
                #!/usr/bin/env bash
                shopt -s globstar nocaseglob

                # Define your music library directory
                MUSIC_DIR="${music}"

                # Navigate to the music directory
                cd "$MUSIC_DIR" || exit

                # Loop through each music file
                for file in **/*.{flac,mp3,m4a,opus}; do
                  # Extract the base name without extension
                  base_name="''${file%.*}"
                  # Define the output .lrc file path
                  lrc_file="''${base_name}.lrc"

                  # Extract lyrics using ffprobe
        	lyrics=$(ffprobe -loglevel error -show_entries stream_tags=lyrics -of default=noprint_wrappers=1:nokey=1 "$file")

                  # Check if lyrics were found
                  if [ -n "$lyrics" ]; then
                    # Save lyrics to the .lrc file
                    echo -e "$lyrics" > "$lrc_file"
                    echo "Lyrics extracted for '$file' to '$lrc_file'."
                  else
                    echo "No embedded lyrics found in '$file'."
                  fi
                done
      '';
  };
in
{
  config = mkIf config.custom.beets.enable {
    home.packages = [ extractLyrics ];
    programs.beets = {
      enable = true;
      package = beets.override {
        pluginOverrides = {
          copyartifacts = {
            enable = true;
            propogatedBuildInputs = [ beetsPackages.copyartifacts ];
          };
        };
      };
      settings = {
        directory = "${config.xdg.userDirs.music}";
        library = "${config.xdg.configHome}/beets/library.db";
        import = {
          incremental = true;
          log = "${config.xdg.configHome}/beets/import.log";
          move = true;
          quiet = false;
          quiet_fallback = "asis";
        };
        paths = {
          comp = "Compilations/$album/$track $title";
          default = "$albumartist/$album%aunique{}/$disc-$track $title";
          singleton = "Non-Album/$artist/$title";
        };
        plugins = [
          "badfiles"
          "chroma"
          #BUG: While copyartifacts installs with the override beets does not recognize it.
          # ** error loading plugin copyartifacts:
          # Traceback (most recent call last):
          #   File "/nix/store/div1hlsqd72m2wdcr87lb47a9msfs2w5-beets-2.2.0/lib/python3.12/site-packages/beets/plugins.py", line 268, in load_plugins
          #     namespace = __import__(modname, None, None)
          #                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          # ModuleNotFoundError: No module named 'beetsplug.copyartifacts'
          #
          # "copyartifacts"
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
          "web"
        ];
        # copyartifacts = {
        #   extensions = ".lrc";
        #   print_ignored = true;
        # };
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

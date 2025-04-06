{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.xdg.userDirs) music;
  inherit (lib) types mkOption mkEnableOption;
  inherit (pkgs)
    cava
    html-xml-utils
    imagemagick
    inotify-tools
    mpc-cli
    playerctl
    pup
    streamrip
    writeShellApplication
    ;

  musicDirectory = music;
  fallbackImage = ../../unknown.jpeg;

in
{
  imports = [
    ./beets.nix
    ./mpd.nix
    ./ncmpcpp.nix
    ./rmpc.nix
    ./sptlrx.nix
  ];

  options.custom = {
    beets = {
      enable = mkEnableOption "beets";
      default = true;
    };
    mpd = {
      enable = mkEnableOption "MPD";
      default = true;
    };
    ncmpcpp = {
      enable = mkEnableOption "ncmpcpp";
      default = false;
    };
    rmpc = {
      enable = mkEnableOption "rmpc";
      default = true;
    };

    mpdSongChange = {
      enable = mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the mpd-song-change script.";
      };
      package = mkOption {
        type = types.package;
        default = writeShellApplication {
          name = "mpd-song-change";
          runtimeInputs = [
            cava
            html-xml-utils
            imagemagick
            inotify-tools
            mpc-cli
            playerctl
            pup
            streamrip
          ];
          text =
            # bash
            ''
              #!/usr/bin/env bash
              find_cover () {
                ext="$(mpc --format %file% current | sed 's/^.*\.//')"

                if [ "$ext" == "flac" ]; then
                  metaflac --export-picture-to=/tmp/cover.jpg \
                  "$(mpc --format "${musicDirectory}"/%file% current)" && cover_path="/tmp/cover.jpg" && return
                else
                  ffmpeg -y -i "$(mpc --format "${musicDirectory}"/%file% | head -n 1)" \
                  /tmp/cover.jpg && cover_path="/tmp/cover.jpg" && return
                fi

                file="${musicDirectory}/$(mpc --format %file% current)"
                album="''${file%/*}"
                cover_path=$(find "$album" -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
              }
              find_cover 2>/dev/null
              magick "''${cover_path:-${fallbackImage}}" /tmp/cover.jpg
              notify-send -i "''${cover_path:-${fallbackImage}}" "Now Playing" "$(mpc current)" -h string:x-dunst-stack-tag:vol 2>/dev/null
            '';
        };
      };
    };
  };

  config = {
    custom.persist.home.directories = [ "Music" ];
  };
}

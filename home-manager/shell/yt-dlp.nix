{ config, pkgs, ... }:
let
  mkFormat =
    height: ''"bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'';

  # Function to create yt-dlp wrappers
  mkYtDlpWrapper = _args: {
    runtimeInputs = with pkgs; [
      gawk
      yt-dlp
    ];
    text = # sh
      ''
        is_flag() { [[ "$1" == -* ]]; }

        args=()
        has_positional=false

        for arg in "$@"; do
            if ! is_flag "$arg"; then
                has_positional=true
            fi
            args+=("$arg")
        done

        if ! $has_positional; then
            while IFS= read -r url; do
                [[ $url == http* ]] && args+=("$url")
            done < <(awk '!x[$0]++' "${config.xdg.userDirs.desktop}/yt.txt")
        fi

        pushd "${config.xdg.userDirs.download}" > /dev/null
          yt-dlp  "''${args[@]}"
        popd > /dev/null

      '';
  };
  # Function to create yt-dlp music wrapper for individual tracks
  mkMusicWrapper = _args: {
    runtimeInputs = with pkgs; [
      yt-dlp
      gawk
    ];
    text = # sh
      ''
          is_flag() { [[ "$1" == -* ]]; }

          args=()
          has_positional=false

          for arg in "$@"; do
              if ! is_flag "$arg"; then
                  has_positional=true
              fi
              args+=("$arg")
          done

          if ! $has_positional; then
              while IFS= read -r url; do
                  [[ $url == http* ]] && args+=("$url")
              done < <(awk '!x[$0]++' "${config.xdg.userDirs.desktop}/ytmusic.txt")
          fi


        pushd "${config.xdg.userDirs.music}" > /dev/null
              yt-dlp -f bestaudio \
                  --extract-audio \
                  --parse-metadata 'playlist_title:%(album)s' \
                  --parse-metadata 'artist:%(artist)s' \
                  --parse-metadata 'album_artist:%(album_artist)s' \
                  --parse-metadata 'track:%(track_number)s' \
                  --parse-metadata 'disc:%(disc_number)s' \
                  --parse-metadata 'genre:%(genre)s' \
                  "''${args[@]}"
          popd > /dev/null
      '';
  };
  # Function to create yt-dlp music wrapper for individual tracks
  mkMusicPlaylistWrapper = _args: {
    runtimeInputs = with pkgs; [
      yt-dlp
      gawk
    ];
    text = # sh
      ''
                  is_flag() { [[ "$1" == -* ]]; }

                  args=()
                  has_positional=false

                  for arg in "$@"; do
                      if ! is_flag "$arg"; then
                          has_positional=true
                      fi
                      args+=("$arg")
                  done

                  if ! $has_positional; then
                      while IFS= read -r url; do
                          [[ $url == http* ]] && args+=("$url")
                      done < <(awk '!x[$0]++' "${config.xdg.userDirs.desktop}/ytmusic.txt")
                  fi


                pushd "${config.xdg.userDirs.music}" > /dev/null
                      yt-dlp -f bestaudio \
                          --extract-audio \
                          --parse-metadata 'playlist_title:%(album)s' \
                          --parse-metadata 'artist:%(artist)s' \
                          --parse-metadata 'album_artist:%(album_artist)s' \
                          --parse-metadata 'track:%(track_number)s' \
                          --parse-metadata 'disc:%(disc_number)s' \
                          --parse-metadata 'genre:%(genre)s' \
        --output '%(playlist_title)s/%(title)s.%(ext)s' \
                          "''${args[@]}"
                  popd > /dev/null
      '';
  };
in
{
  programs.yt-dlp = {
    enable = true;
    package = pkgs.yt-dlp;
    settings = {
      embed-chapters = true;
      embed-metadata = true;
      embed-thumbnail = true;
      format = mkFormat 720;
      no-mtime = true;
      output = "%(title)s.%(ext)s";
      sponsorblock-mark = "all";
      windows-filenames = true;
    };
  };

  home = {
    shellAliases.yt = "yt-dlp";
  };

  custom.shell.packages = {
    yt1080 = mkYtDlpWrapper "--format ${mkFormat 1080}";
    ytdl = mkYtDlpWrapper "--no-cache";
    ytaudio = mkYtDlpWrapper "--audio-format mp3 --extract-audio";
    ytmusic = mkMusicWrapper "";
    #HACK: Make this work with mkMusicWrapper instead of another wrapper.
    ytmusiclist = mkMusicPlaylistWrapper "";
    ytsub = mkYtDlpWrapper "--write-auto-sub --sub-lang='en,eng' --convert-subs srt";
    ytsubonly = mkYtDlpWrapper "--write-auto-sub --sub-lang='en,eng' --convert-subs srt --skip-download --write-subs";
    ytplaylist = mkYtDlpWrapper "--output '${config.xdg.userDirs.download}/%(playlist_index)d - %(title)s.%(ext)s'";
  };
}

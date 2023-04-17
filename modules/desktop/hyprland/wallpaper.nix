{
  pkgs,
  inputs,
  system,
  user,
  ...
}: let
  # sets up all the colors but DOES NOT change the wallpaper
  hypr-reset =
    pkgs.writeShellScriptBin "hypr-reset"
    /*
    sh
    */
    ''
      source /home/${user}/.cache/wal/colors-hexless.sh

      # hyprland doesnt accept leading #

      hyprctl keyword general:col.active_border "rgb(''${color4}) rgb(''${color6}) 45deg";
      hyprctl keyword general:col.inactive_border "rgb(''${color0})";

      # pink border for monocle windows
      hyprctl keyword windowrulev2 bordercolor "rgb(''${color5}),fullscreen:1"
      # teal border for floating windows
      hyprctl keyword windowrulev2 bordercolor "rgb(''${color6}),floating:1"
      # yellow border for sticky (must be floating) windows
      hyprctl keyword windowrulev2 bordercolor "rgb(''${color3}),pinned:1"

      swww query || swww init
      if [ -z "$1" ]; then
        swww img --transition-type grow "$(< "/home/${user}/.cache/wal/wal")"
      else
        swww img --transition-type grow "$1"
      fi

      launch-waybar
    '';
  # sets a random wallpaper and changes the colors
  hypr-wallpaper =
    pkgs.writeShellScriptBin "hypr-wallpaper"
    /*
    sh
    */
    ''
      wal -n -i "/home/${user}/Pictures/Wallpapers"

      hypr-reset
    '';
  # applies a set theme
  hypr-theme =
    pkgs.writeShellScriptBin "hypr-theme"
    /*
    sh
    */
    ''
      theme=''${1:-catppuccin-mocha}

      wal --theme "$theme"

      if [ $theme = "catppuccin-mocha" ]; then
        hypr-reset "${../wallpapers/gits-catppuccin.jpg}"
      else
        hypr-reset
      fi
    '';
  # creating an overlay for buildRustPackage overlay
  # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
  swww =
    inputs.nixpkgs-wayland.packages.${system}.swww.overrideAttrs
    (old: rec {
      src = pkgs.fetchFromGitHub {
        owner = "Horus645";
        repo = "swww";
        rev = "8e18928ece6c0d3d03c6a91695065068cea5f36e";
        sha256 = "sha256-AkJ3XCTxlnrtz00gJwMqeYzAkFmcb1PUCyXlDtI8xBQ=";
      };

      cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = src + "/Cargo.lock";
        allowBuiltinFetchGit = true;
      };
    });
in {
  config = {
    home-manager.users.${user} = {
      home = {
        packages = [
          hypr-reset
          hypr-theme
          hypr-wallpaper
          swww
        ];
      };
    };
  };
}

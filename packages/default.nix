{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs) callPackage;
  repo_url = "https://raw.githubusercontent.com/elias-ainsworth/dotfiles";
in
rec {
  default = install;

  install = pkgs.writeShellApplication {
    name = "thorneos-install";
    runtimeInputs = [ pkgs.curl ];
    text = # sh
      "sh <(curl -L ${repo_url}/main/install.sh)";
  };

  recover = pkgs.writeShellApplication {
    name = "thorneos-recover";
    runtimeInputs = [ pkgs.curl ];
    text = # sh
      "sh <(curl -L ${repo_url}/main/recover.sh)";
  };

  # ricing glue
  dotfiles-rs = callPackage ./dotfiles-rs { };
  dotfiles-hyprland = callPackage ./dotfiles-rs { wm = "hyprland"; };
  dotfiles-niri = callPackage ./dotfiles-rs { wm = "niri"; };

  # custom tela built with tokyo-night variant colors
  tela-dynamic-icon-theme = callPackage ./tela-dynamic-icon-theme {
    colors = {
      default = "#2e7de9";
      green = "#387068";
      grey = "#414868";
      orange = "#b15c00";
      pink = "#d20065";
      purple = "#7847bd";
      red = "#f52a65";
      teal = "#118c74";
      yellow = "#8c6c3e";
    };
  };

  distro-grub-themes-nixos = callPackage ./distro-grub-themes-nixos { };

  hyprnstack = callPackage ./hyprnstack { };
  hypr-darkwindow = callPackage ./hypr-darkwindow { };

  helium = callPackage ./helium { };

  path-of-building = callPackage ./path-of-building { };

  # mpv plugins
  mpv-cut = callPackage ./mpv-cut {
    configLua = ''
      KEY_BOOKMARK_ADD = ""
    '';
  };
  mpv-deletefile = callPackage ./mpv-deletefile { };
  mpv-nextfile = callPackage ./mpv-nextfile { };
  mpv-sub-select = callPackage ./mpv-sub-select { };
  mpv-subsearch = callPackage ./mpv-subsearch { };

  # for nixos-rebuild
  nsw = callPackage ./nsw { };

  rofi-themes = callPackage ./rofi-themes { };
  rofi-power-menu = callPackage ./rofi-power-menu { };
  rofi-wifi-menu = callPackage ./rofi-wifi-menu { };

  tokyo-night-kvantum = callPackage ./tokyo-night-kvantum { };
}

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
      Default = "#78a9ff"; # (base09, calm blue)
      Green = "#42be65"; # (base0D, IBM green)
      Grey = "#393939"; # (base02, neutral)
      Orange = "#ee5396"; # (base0A, pink-ish accent)
      Pink = "#ff7eb6"; # (base0C, true pink)
      Purple = "#be95ff"; # (base0E, IBM purple)
      Red = "#3ddbd9"; # (base08, cyan-ish red replacement)
      Teal = "#08bdba"; # (base07, teal accent)
      Yellow = "#82cfff"; # (base0F, light blue substitute for yellow)
    };
  };

  distro-grub-themes-nixos = callPackage ./distro-grub-themes-nixos { };

  hyprnstack = callPackage ./hyprnstack { };
  hypr-darkwindow = callPackage ./hypr-darkwindow { };

  path-of-building = callPackage ./path-of-building { };

  # mpv plugins
  mpv-cut = callPackage ./mpv-cut { };
  mpv-deletefile = callPackage ./mpv-deletefile { };
  mpv-nextfile = callPackage ./mpv-nextfile { };
  mpv-sub-select = callPackage ./mpv-sub-select { };
  mpv-subsearch = callPackage ./mpv-subsearch { };

  # for nixos-rebuild
  hsw = callPackage ./hsw { };
  nsw = callPackage ./nsw { };

  rofi-themes = callPackage ./rofi-themes { };
  rofi-power-menu = callPackage ./rofi-power-menu { };
  rofi-wifi-menu = callPackage ./rofi-wifi-menu { };

  tokyo-night-kvantum = callPackage ./tokyo-night-kvantum { };
}

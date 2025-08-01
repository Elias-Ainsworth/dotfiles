{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs) lib callPackage;
  # injects a source parameter from nvfetcher
  # adapted from viperML's config
  # https://github.com/viperML/dotfiles/blob/master/packages/default.nix
  w =
    _callPackage: path: extraOverrides:
    let
      sources = pkgs.callPackages (path + "/generated.nix") { };
      firstSource = lib.head (lib.attrValues sources);
    in
    _callPackage (path + "/default.nix") (
      extraOverrides // { source = lib.filterAttrs (k: _: !(lib.hasPrefix "override" k)) firstSource; }
    );
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
  dotfiles-rs-hyprland = callPackage ./dotfiles-rs { wm = "hyprland"; };
  dotfiles-rs-niri = callPackage ./dotfiles-rs { wm = "niri"; };

  # custom tela built with catppucin variant colors
  tela-dynamic-icon-theme = callPackage ./tela-dynamic-icon-theme {
    colors = {
      blue = "#89b4fa";
      flamingo = "#f2cdcd";
      green = "#a6e3a1";
      lavender = "#b4befe";
      maroon = "#eba0ac";
      mauve = "#cba6f7";
      peach = "#fab387";
      pink = "#f5c2e7";
      red = "#f38ba8";
      rosewater = "#f5e0dc";
      sapphire = "#74c7ec";
      sky = "#89dceb";
      teal = "#94e2d5";
      yellow = "#f9e2af";
    };
  };

  distro-grub-themes-nixos = callPackage ./distro-grub-themes-nixos { };

  hyprnstack = callPackage ./hyprnstack { };
  hypr-darkwindow = callPackage ./hypr-darkwindow { };

  path-of-building = w callPackage ./path-of-building { };

  # mpv plugins
  mpv-cut = w pkgs.mpvScripts.callPackage ./mpv-cut { };
  mpv-deletefile = w pkgs.mpvScripts.callPackage ./mpv-deletefile { };
  mpv-nextfile = w pkgs.mpvScripts.callPackage ./mpv-nextfile { };
  mpv-sub-select = w pkgs.mpvScripts.callPackage ./mpv-sub-select { };
  mpv-subsearch = w pkgs.mpvScripts.callPackage ./mpv-subsearch { };

  # for nixos-rebuild
  hsw = callPackage ./hsw { };
  nsw = callPackage ./nsw { };

  rofi-themes = w callPackage ./rofi-themes { };
  rofi-power-menu = callPackage ./rofi-power-menu { };
  rofi-wifi-menu = callPackage ./rofi-wifi-menu { };
}

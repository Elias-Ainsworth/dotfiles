{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
{
  dotfiles-rs = callPackage ./dotfiles-rs { };

  tela-dynamic-icon-theme = callPackage ./tela-dynamic-icon-theme { };

  distro-grub-themes-nixos = callPackage ./distro-grub-themes-nixos { };

  helium = callPackage ./helium { };

  hyprnstack = callPackage ./hyprnstack { };

  nsw = callPackage ./nsw { };

  rofi-themes = callPackage ./rofi-themes { };
  rofi-power-menu = callPackage ./rofi-power-menu { };
  rofi-wifi-menu = callPackage ./rofi-wifi-menu { };

  tokyo-night-kvantum = callPackage ./tokyo-night-kvantum { };
}

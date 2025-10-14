{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (types) listOf package str;
in
{
  options.custom = {
    fonts = {
      regular = mkOption {
        type = str;
        default = "Geist";
        description = "The font to use for regular text";
      };
      weeb = mkOption {
        type = str;
        default = "Mamelon";
        description = "The font to use for weeb text";
      };
      monospace = mkOption {
        type = str;
        default = "JetBrainsMono Nerd Font"; # Idk I honestly like "Geist Mono NerdFont" as well.
        description = "The font to use for monospace text";
      };
      packages = mkOption {
        type = listOf package;
        description = "The packages to install for the fonts";
      };
    };
  };

  config = {
    # setup fonts for other distros, run "fc-cache -f" to refresh fonts
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = rec {
          serif = [
            "${config.custom.fonts.regular}"
            "${config.custom.fonts.weeb}"
          ];
          sansSerif = serif;
          monospace = [
            "${config.custom.fonts.monospace}"
            "${config.custom.fonts.weeb}"
          ];
        };
      };
    };

    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
        inputs.mamelon.packages.${system}.default
        (iosevka-bin.override { variant = "Etoile"; })
      ];
    };
  };
}

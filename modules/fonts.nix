{
  flake.nixosModules.core =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption;
    in
    {
      options.custom = {

        fonts = {
          regular = mkOption {
            type = lib.types.str;
            default = "Geist";
            description = "The font to use for regular text";
          };
          weeb = mkOption {
            type = lib.types.str;
            default = "Mamelon";
            description = "The font to use for weeb text";
          };
          monospace = mkOption {
            type = lib.types.str;
            default = "JetBrainsMono Nerd Font"; # Idk I honestly like "Geist Mono NerdFont" as well.
            description = "The font to use for monospace text";
          };
        };
      };

      config = {
        # setup fonts for other distros, run "fc-cache -f" to refresh fonts
        fonts.fontconfig.enable = true;

        fonts = {
          enableDefaultPackages = true;

          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            nerd-fonts.iosevka
            nerd-fonts.jetbrains-mono
            inputs.mamelon.packages.${system}.default
            (iosevka-bin.override { variant = "Etoile"; })
          ];
        };
      };
    };
}

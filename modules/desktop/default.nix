{ pkgs, user, lib, ... }: {
  imports = [
    # bspwm are mutually exclusive via a config option
    ./bspwm.nix
    ./gnome3.nix
  ];

  options.iynaix = {
    font = {
      regular = lib.mkOption {
        type = lib.types.str;
        default = "Inter";
        description = "The font to use for regular text";
      };
      monospace = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "The font to use for monospace text";
      };
    };
    displays = {
      monitor1 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The name of the primary display, e.g. eDP-1";
      };
      monitor2 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The name of the secondary display, e.g. eDP-1";
      };
      monitor3 = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The name of the tertiary display, e.g. eDP-1";
      };
    };
  };

  config = {
    home-manager.users.${user} = {
      home = {
        # xresources
        file.".Xresources".source = ./.Xresources;

        # copy wallpapers
        file."Pictures/Wallpapers" = {
          source = ./wallpapers;
          recursive = true;
        };
      };
    };
  };
}

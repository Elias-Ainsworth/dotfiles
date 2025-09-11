{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) attrNames mkIf mkOption;
  inherit (lib.types) attrsOf enum str;
in
{
  options.custom = {
    gtk = {
      accents = mkOption {
        type = attrsOf str;

        default = {
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
        description = "GTK theme accents";
      };

      defaultAccent = mkOption {
        type = enum (attrNames config.custom.gtk.accents);
        default = "Default";
        description = "Default GTK theme accent";
      };
    };
  };

  config =
    let
      inherit (config.custom.gtk) accents defaultAccent;
    in
    mkIf (config.custom.wm != "tty") {
      home = {
        pointerCursor = {
          package = pkgs.simp1e-cursors;
          name = "Simp1e-Tokyo-Night";
          size = 28;
          gtk.enable = true;
          x11.enable = true;
          hyprcursor.enable = config.custom.wm == "hyprland";
        };
      };

      dconf.settings = {
        # disable dconf first use warning
        "ca/desrt/dconf-editor" = {
          show-warning = false;
        };
        # set dark theme for gtk 4
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-theme = config.home.pointerCursor.name;
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Oxocarbon-Dark";
          package = pkgs.colloid-gtk-theme.override {
            colorVariants = [ "dark" ];
            sizeVariants = [ "compact" ];
            themeVariants = [ "all" ];
          };
        };
        iconTheme = {
          name = "Tela-${defaultAccent}-dark";
          package = pkgs.custom.tela-dynamic-icon-theme.override { colors = accents; };
        };
        font = {
          name = config.custom.fonts.regular;
          package = pkgs.geist-font;
          size = 10;
        };
        gtk2 = {
          configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
          force = true; # plasma seems to override this file?
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-error-bell = 0;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-error-bell = 0;
        };
      };

      qt.enable = true;

      # write theme accents into nix.json for rust to read
      custom.wallust.nixJson = {
        themeAccents = accents;
      };
    };
}

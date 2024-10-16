{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.rofi;
  rofiThemes = pkgs.custom.rofi-themes;
  launcherType = 2;
  launcherStyle = 2;
  powermenuType = 4;
  powermenuStyle = 3;
  powermenuDir = "${rofiThemes}/powermenu/type-${toString powermenuType}";
  themeStyles =
    if cfg.theme != null then
      ''@import "${rofiThemes}/colors/${cfg.theme}.rasi"''
    else
      ''
        * {
            background:     {{background}}{{ 60 | alpha_hexa }};
            background-alt: {{color0}};
            foreground:     {{foreground}};
            selected:       {{color4}};
            active:         {{color6}};
            urgent:         {{color1}};
        }
      '';

  # replace the imports with preset theme / wallust
  fixupRofiThemesRasi = rasiPath: overrideStyles: ''
    ${themeStyles}
    ${lib.replaceStrings
      [
        "@import"
        ""
      ]
      [
        "// @import"
        ""
      ]
      (lib.readFile rasiPath)
    }
    window {
      width: ${toString cfg.width}px;
    }

    element normal.normal { background-color: transparent; }
    inputbar { background-color: transparent; }
    message { background-color: transparent; }
    textbox { background-color: transparent; }

    ${overrideStyles}
  '';
in
{
  options.custom = with lib; {
    rofi = {
      theme = mkOption {
        type = types.nullOr (
          types.enum [
            "adapta"
            "arc"
            "black"
            "catppuccin"
            "cyberpunk"
            "dracula"
            "everforest"
            "gruvbox"
            "lovelace"
            "navy"
            "nord"
            "onedark"
            "paper"
            "solarized"
            "tokyonight"
            "yousai"
          ]
        );
        default = null;
        description = "Rofi launcher theme";
      };
      width = mkOption {
        type = types.int;
        default = 800;
        description = "Rofi launcher width";
      };
    };
  };

  config = lib.mkIf (!config.custom.headless) {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        plugins = [ rofiThemes ];
      };
      extraConfig = {
        show-icons = true;
        kb-remove-char-back = "BackSpace";
        kb-accept-entry = "Control+m,Return,KP_Enter";
        kb-mode-next = "Control+l";
        kb-mode-previous = "Control+h";
        kb-row-up = "Control+k,Up";
        kb-row-down = "Control+j,Down";
        kb-row-left = "Control+u";
        kb-row-right = "Control+d";
        kb-delete-entry = "Control+semicolon";
        kb-remove-char-forward = "";
        kb-remove-to-sol = "";
        kb-remove-to-eol = "";
        kb-mode-complete = "";
      };
      theme = "${config.xdg.cacheHome}/wallust/rofi.rasi";
    };

    xdg.dataFile."rofi/themes/preview.rasi".text = ''
      @theme "custom"
      icon-current-entry {
        enabled: true;
        size: 50%;
        dynamic: true;
        padding: 10px;
        background-color: inherit;
      }
      listview-split {
        background-color: transparent;
        border-radius: 0px;
        cycle: true;
        dynamic : true;
        orientation: horizontal;
        border: 0px solid;
        children: [listview,icon-current-entry];
      }
      listview {
        lines: 10;
      }
      mainbox {
        children: [inputbar,listview-split];
      }
      @media (enabled: env(EPUB, false)) {
        icon-current-entry {
          size: 35%;
        }
      }

    '';
    custom.shell.packages = {
      # NOTE: rofi-power-menu only works for powermenuType = 4!
      rofi-power-menu = {
        runtimeInputs = with pkgs; [
          rofi-wayland
          custom.rofi-themes
        ];
        text = lib.readFile ./rofi-power-menu.sh;
      };
      rofi-wifi-menu = {
        runtimeInputs = with pkgs; [
          libnotify
          rofi-wayland
          custom.rofi-themes
        ];
        text = lib.readFile ./rofi-wifi-menu.sh;
      };
      rofi-epub-menu = {
        runtimeInputs = with pkgs; [
          rofi-wayland
          custom.rofi-themes
        ];
        text = lib.readFile ./rofi-epub-menu.sh;
      };
      rofi-pdf-menu = {
        runtimeInputs = with pkgs; [
          rofi-wayland
          custom.rofi-themes
        ];
        text = lib.readFile ./rofi-pdf-menu.sh;
      };
    };

    # add blur for rofi shutdown
    wayland.windowManager.hyprland.settings = {
      layerrule = [
        "blur,rofi"
        "ignorealpha 0,rofi"
      ];

      # force center rofi on monitor
      windowrulev2 = [
        "float,class:(Rofi)"
        "center,class:(Rofi)"
        "rounding 12,class:(Rofi)"
      ];
    };

    custom.wallust.templates = lib.mkIf config.programs.rofi.enable {
      # default launcher
      "rofi.rasi" = {
        text = fixupRofiThemesRasi "${rofiThemes}/launchers/type-${toString launcherType}/style-${toString launcherStyle}.rasi" ''
          inputbar { background-color: transparent; }
          element normal.normal { background-color: transparent; }
        '';
        target = "${config.xdg.cacheHome}/wallust/rofi.rasi";
      };

      # generic single column rofi menu
      "rofi-menu.rasi" = {
        text = fixupRofiThemesRasi "${rofiThemes}/launchers/type-${toString launcherType}/style-${toString launcherStyle}.rasi" ''
          listview { columns: 1; }
          prompt { enabled: false; }
          textbox-prompt-colon { enabled: false; }
        '';
        target = "${config.xdg.cacheHome}/wallust/rofi-menu.rasi";
      };

      "rofi-menu-noinput.rasi" = {
        text = fixupRofiThemesRasi "${rofiThemes}/launchers/type-${toString launcherType}/style-${toString launcherStyle}.rasi" ''
          listview { columns: 1; }
          * { width: 1000; }
          window { height: 625; }
          mainbox {
              children: [listview,message];
          }
          message {
            padding:                     15px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @selected;
            /* background-color is set in style overrides */
            text-color:                  @foreground;
          }
        '';
        target = "${config.xdg.cacheHome}/wallust/rofi-menu-noinput.rasi";
      };

      "rofi-power-menu.rasi" = {
        text = lib.replaceStrings [ "Iosevka Nerd Font" ] [ "DejaVu Sans" ] (
          fixupRofiThemesRasi "${powermenuDir}/style-${toString powermenuStyle}.rasi" ''
            * { background-window: @background; } // darken background
            window {
              width: 1000px;
              border-radius: 12px; // no rounded corners as it doesn't interact well with blur on hyprland
            }
            element normal.normal { background-color: var(background-normal); }
            element selected.normal { background-color: @selected; }
          ''
        );
        target = "${config.xdg.cacheHome}/wallust/rofi-power-menu.rasi";
      };

      "rofi-power-menu-confirm.rasi" = {
        text = fixupRofiThemesRasi "${powermenuDir}/shared/confirm.rasi" ''
          element { background-color: transparent; }
          element normal.normal { background-color: transparent; }
        '';
        target = "${config.xdg.cacheHome}/wallust/rofi-power-menu-confirm.rasi";
      };
    };
  };
}

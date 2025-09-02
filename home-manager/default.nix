{
  config,
  isNixOS,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
let
  inherit (lib)
    hasPrefix
    mapAttrsToList
    mkEnableOption
    mkOption
    optionals
    ;
  inherit (lib.types)
    attrsOf
    bool
    listOf
    nullOr
    package
    str
    ;
in
{
  options.custom = {
    autologinCommand = mkOption {
      type = nullOr str;
      default = null;
      description = "Command to run after autologin";
    };
    colorscheme = {
      theme = mkOption {
        type = str;
        default = "oxocarbon";
        description = "System colorscheme";
      };
      transparent = mkOption {
        type = bool;
        default = false;
        description = "Whether to enable transparency";
      };
      variant = mkOption {
        type = str;
        default = "dark";
        description = "System colorscheme variant";
      };
    };
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
    specialisation = {
      current = mkOption {
        type = str;
        default = "";
        description = "The current specialisation being used";
      };

      hyprland.enable = mkEnableOption "hyprland specialisation";
      niri.enable = mkEnableOption "niri specialisation";
      mango.enable = mkEnableOption "mango specialisation";
    };
    symlinks = mkOption {
      type = attrsOf str;
      default = { };
      description = "Symlinks to create in the format { dest = src;}";
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

    home = {
      username = user;
      homeDirectory = "/home/${user}";
      # do not change this value
      stateVersion = "23.05";

      sessionVariables = {
        __IS_NIXOS = if isNixOS then "1" else "0";
        __SPECIALISATION = config.custom.specialisation.current;
        NIXPKGS_ALLOW_UNFREE = "1";
      };

      packages =
        with pkgs;
        [
          curl
          gzip
          libreoffice
          trash-cli
          xdg-utils
        ]
        ++ (optionals config.custom.helix.enable [ helix ])
        # home-manager executable only on nixos
        ++ (optionals isNixOS [ home-manager ])
        # handle fonts
        ++ (optionals (!isNixOS) config.custom.fonts.packages);
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # create symlinks
    systemd.user.tmpfiles.rules =
      let
        normalizeHome = p: if (hasPrefix "/home" p) then p else "${config.home.homeDirectory}/${p}";
      in
      mapAttrsToList (dest: src: "L+ ${normalizeHome dest} - - - - ${src}") config.custom.symlinks;

    xdg = {
      enable = true;
      userDirs.enable = true;
      mimeApps.enable = true;
    };

    custom = {
      fonts.packages = with pkgs; [
        inputs.mamelon.packages.${system}.default
        nerd-fonts.iosevka
        nerd-fonts.geist-mono
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        (iosevka-bin.override { variant = "Etoile"; })
      ];

      persist = {
        home.directories = [
          "Books"
          "Desktop"
          "Documents"
          "Pictures"
          ".config/libreoffice"
        ];
      };
    };
  };
}

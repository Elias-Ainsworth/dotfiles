{
  config,
  isNixOS,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    mkIf
    mkOption
    ;
  inherit (lib.types)
    package
    str
    ;
in
{
  options.custom = {
    terminal = {
      package = mkOption {
        type = package;
        default = config.programs.ghostty.package;
        description = "Package to use for the terminal.";
      };

      app-id = mkOption {
        type = str;
        description = "app-id (wm class) for the terminal";
      };

      desktop = mkOption {
        type = str;
        default = "${config.custom.terminal.package.pname}.desktop";
        description = "Name of desktop file for the terminal";
      };
    };
  };

  config = {
    home.packages =
      with pkgs;
      [
        dysk # better disk info
        ets # add timestamp to beginning of each line
        fd # better find
        fx # terminal json viewer and processor
        htop
        jq
        mdt # terminal markdown viewer and processor
        ouch # better compression and decompression utility
        presenterm # markdown to presentation
        procs # better ps
        sd # better sed
        ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
      ]
      # add custom user created shell packages
      ++ (attrValues config.custom.shell.packages);

    # add custom user created shell packages to pkgs.custom.shell
    nixpkgs.overlays = mkIf (!isNixOS) [
      (_: prev: {
        custom = (prev.custom or { }) // {
          shell = config.custom.shell.packages;
        };
      })
    ];

    programs = {
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = false;
      };
    };

    custom.persist = {
      home = {
        cache.directories = [ ".local/share/zoxide" ];
      };
    };
  };
}

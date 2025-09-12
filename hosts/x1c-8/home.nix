{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  custom = {
    specialisation = {
      niri.enable = true;
      mango.enable = true;
    };

    monitors = [
      {
        name = "DP-5";
        width = 1920;
        height = 1080;
        refreshRate = 75;
        # scale = 1.5;
        vrr = true;
        transform = 3;
        positionX = 0;
        positionY = 0;
        workspaces = [
          1
          2
          3
          4
        ];
      }
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        scale = 1.5;
        vrr = true;
        positionX = 1080;
        positionY = 0;
        workspaces = [
          5
          6
        ];
      }
      {
        name = "DP-6";
        width = 1920;
        height = 1080;
        refreshRate = 75;
        # scale = 1.5;
        vrr = true;
        positionX = 2360;
        positionY = 0;
        workspaces = [
          7
          8
          9
          10
        ];
      }
    ];

    colorscheme = {
      theme = "tokyonight";
      variant = "night";
    };
    fonts = {
      regular = "Iosevka Etoile";
      monospace = "Iosevka Nerd Font";
    };
    gamma.enable = true;
    helix.enable = true;
    modelling3d.enable = false;
    printing3d.enable = false;
    pathofbuilding.enable = false;
    rclip.enable = true;
    wallfacer.enable = true;
    waybar.hidden = false;

    # don't blind me on startup
    startup = [
      {
        spawn = [
          (getExe pkgs.brightnessctl)
          "s"
          "50%"
        ];
      }
    ];

    persist = {
      home.directories = [ "Downloads" ];
    };
  };
}

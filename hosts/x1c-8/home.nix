{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  custom = {
    monitors = [
      {
        name = "DP-5";
        width = 1920;
        height = 1080;
        refreshRate = 75;
        # scale = 1.5;
        vrr = true;
        position-x = 0;
        position-y = 0;
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
        position-x = 1920;
        position-y = 0;
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
        position-x = 3840;
        position-y = 0;
        workspaces = [
          7
          8
          9
          10
        ];
      }
    ];

    fonts = {
      regular = "Iosevka Etoile";
      monospace = "Iosevka Nerd Font";
    };
    gamma.enable = true;
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

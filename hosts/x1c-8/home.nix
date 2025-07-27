{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  custom = {
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 120;
        scale = 1.5;
        vrr = true;
        workspaces = [
          1
          2
          3
          4
          5
          6
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
          "20%"
        ];
      }
    ];

    persist = {
      home.directories = [ "Downloads" ];
    };
  };
}

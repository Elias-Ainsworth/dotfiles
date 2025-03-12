{
  config,
  lib,
  pkgs,
  ...
}:
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
        refreshRate = if config.specialisation == "otg" then 120 else 60;
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

    deadbeef.enable = true;
    gaming.enable = false;
    ghostty.enable = true;
    modelling3d.enable = true;
    mpd.enable = true;
    ncmpcpp.enable = true;
    rmpc.enable = true;
    printing3d.enable = true;
    pathofbuilding.enable = false;
    rclip.enable = true;
    study.enable = true;
    wallfacer.enable = true;
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };

    terminal = {
      package = pkgs.ghostty;
      size = 12;
    };

    persist = {
      home.directories = [
        "Downloads"
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # don't blind me on startup
      "${getExe pkgs.brightnessctl} s 75%"
    ];
  };
}

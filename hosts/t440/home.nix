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

    colorscheme = {
      theme = "gruvbox";
      variant = "dark";
      transparent = true;
    };
    beets.enable = false;
    fonts.monospace = "Geist Mono NerdFont";
    gaming.enable = false;
    ghostty.enable = true;
    helix.enable = true;
    modelling3d.enable = true;
    mpd.enable = true;
    ncmpcpp.enable = true;
    rmpc.enable = false;
    printing3d.enable = true;
    pathofbuilding.enable = false;
    rclip.enable = true;
    study.enable = true;
    vlc.enable = true;
    wallfacer.enable = true;
    # wallust.colorscheme = "oxocarbon";
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };

    terminal = {
      # opacity = "1.0";
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

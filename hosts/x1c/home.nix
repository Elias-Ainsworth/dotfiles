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
        scale = 1.5;
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
    fonts = {
      regular = "Iosevka Etoile";
      monospace = "Iosevka Nerd Font";
    };
    gaming.enable = false;
    gamma.enable = true;
    modelling3d.enable = false;
    mpd.enable = true;
    ncmpcpp.enable = true;
    rmpc.enable = false;
    printing3d.enable = false;
    pathofbuilding.enable = false;
    rclip.enable = true;
    study.enable = true;
    wallfacer.enable = true;
    # wallust.colorscheme = "oxocarbon";
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };

    # don't blind me on startup
    startup = [
      {
        spawn = [
          (getExe pkgs.brightnessctl)
          "s"
          "75%"
        ];
      }
    ];

    persist = {
      home.directories = [
        "Downloads"
      ];
    };
  };
}

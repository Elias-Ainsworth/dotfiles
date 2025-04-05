{ pkgs, ... }:
{
  custom = {
    monitors = [
      {
        name = "LVDS-1";
        width = 1600;
        height = 900;
        refreshRate = 60;
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

    gaming.enable = true;
    ghostty.enable = true;
    hyprland = {
      # plugin = "hyprnstack";
      lock = true;
      qtile = false;
    };
    modelling3d.enable = true;
    mpd.enable = true;
    ncmpcpp.enable = true;
    rmpc.enable = true;
    printing3d.enable = true;
    obs-studio.enable = false;
    pathofbuilding.enable = false;
    rclip.enable = true;
    vlc.enable = false;
    wallfacer.enable = true;
    # wallust.colorscheme = "tokyo-night";
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };

    terminal.package = pkgs.ghostty;

    persist = {
      home.directories = [
        "Downloads"
      ];
    };
  };

  # home = {
  #   packages = with pkgs; [
  #     # hyprlock # build package for testing, but it isn't used
  #   ];
  # };
}

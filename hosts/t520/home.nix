{ pkgs, ... }:
{
  custom = {
    monitors = [
      {
        name = "VGA-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        workspaces = [
          1
          2
          3
          4
          5
        ];
      }
      {
        name = "LVDS-1";
        width = 1600;
        height = 900;
        refreshRate = 60;
        workspaces = [
          6
          7
          8
          9
          10
        ];
        defaultWorkspace = 6;
      }
    ];

    deadbeef.enable = true;
    gaming.enable = true;
    ghostty.enable = true;
    hyprland = {
      # plugin = "hyprnstack";
      lock = true;
      qtile = false;
    };
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
  };

  # home = {
  #   packages = with pkgs; [
  #     # hyprlock # build package for testing, but it isn't used
  #   ];
  # };
}

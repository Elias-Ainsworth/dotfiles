_: {
  custom = {
    monitors = [
      {
        name = "VGA-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        position = "1600x0";
        # scale = 0.83;
        transform = 1;
        workspaces = [
          1
          2
          3
          4
          5
        ];
        defaultWorkspace = 1;
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

    colorscheme.transparent = true;
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
    obs-studio.enable = false;
    printing3d.enable = true;
    pathofbuilding.enable = false;
    rclip.enable = true;
    study.enable = true;
    vlc.enable = false;
    wallfacer.enable = true;
    # wallust.colorscheme = "tokyo-night";
    waybar = {
      enable = true;
      hidden = false;
    };

    persist = {
      home.directories = [
        "Downloads"
      ];
    };
  };
}

_: {
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
        ];
      }
      {
        name = "VGA-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        transform = 1;
        workspaces = [
          6
          7
          8
          9
          10
        ];
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
    };

    persist = {
      home.directories = [
        "Downloads"
      ];
    };
  };
}

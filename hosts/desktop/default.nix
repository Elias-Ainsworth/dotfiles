{
  config,
  pkgs,
  user,
  ...
}: let
  displayCfg = config.iynaix.displays;
  hyprlandCfg = config.iynaix.hyprland;
in {
  imports = [./hardware.nix];

  config = {
    iynaix = {
      # hardware
      am5.enable = true;
      dac.enable = true;
      hdds.enable = true;

      displays = {
        monitor1 = "DP-2";
        monitor2 =
          if hyprlandCfg.enable
          then "DP-4"
          else "DP-0.8";
        monitor3 =
          if hyprlandCfg.enable
          then "HDMI-A-1"
          else "HDMI-0";
      };

      # wayland settings
      hyprland = {
        enable = true;
        nvidia = true;
        monitors = {
          "${displayCfg.monitor1}" = "3440x1440@144,1440x1080,1";
          "${displayCfg.monitor2}" = "2560x1440,0x728,1,transform,1";
          "${displayCfg.monitor3}" = "1920x1080,1754x0,1";
        };
      };
      waybar = {
        style-template = ''
          /* add rounded corners for leftmost modules-right */
          #pulseaudio {{
            border-radius: 12px 0 0 12px;
          }}
        '';
      };

      smplayer.enable = true;
      torrenters.enable = true;
      pathofbuilding.enable = true;
    };

    networking.hostId = "89eaa833"; # required for zfs

    # environment.systemPackages = with pkgs; [ ];

    home-manager.users.${user} = {
      home = {
        packages = with pkgs; [
          vlc
          # vial
        ];
      };

      programs.obs-studio.enable = true;
    };

    # required for vial to work
    # services.udev.extraRules = ''KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"'';

    iynaix.persist.home.directories = [
      ".config/smplayer"
    ];
  };
}

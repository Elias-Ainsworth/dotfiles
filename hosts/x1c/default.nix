{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  custom = {
    hardware = {
      monitors = [
        {
          name = "HDMI-A-1";
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
          name = "eDP-1";
          width = 1920;
          height = 1080;
          scale = 1.5;
          refreshRate = 60;
          workspaces = [
            6
            7
            8
            9
            10
          ];
        }
      ];
      qmk.enable = true;
    };
    colorscheme = {
      theme = "tokyonight";
      variant = "night";
    };
    fonts = {
      regular = "Iosevka Etoile";
      monospace = "Iosevka Nerd Font";
    };
    programs = {
      helix.enable = true;
      pathofbuilding.enable = false;
      rclip.enable = true;
      study.enable = true;
      wallfacer.enable = true;
      waybar.hidden = false;
    };
    services = {
      virtualization.enable = true;
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
      home.directories = [ "Downloads" ];
    };
  };

  networking.hostId = "ec7351ab"; # required for zfs

  services = {
    # touchpad support
    libinput.enable = true;

    # disable thumbprint reader
    fprintd.enable = false;

    # thunderbolt support
    hardware.bolt.enable = true;
  };
}

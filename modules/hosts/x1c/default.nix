topLevel: {
  flake.nixosModules.host-x1c =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getExe;
    in
    {
      imports = with topLevel.config.flake.nixosModules; [
        gui
        wm

        ### programs
        freecad
        helix
        # orca-slicer
        # obs-studio
        # vlc
        music
        wallfacer
        # zoom

        ### hardware
        bluetooth
        # qmk
        laptop

        ### services
        # bittorrent
        docker
        # syncoid
        virtualisation
      ];

      custom = {
        specialisation = {
          niri.enable = true;
          hyprland.enable = lib.mkForce false;
          mango.enable = false;
        };

        hardware = {

          monitors = [
            {
              name = "DP-5";
              width = 1920;
              height = 1080;
              refreshRate = 75;
              # scale = 1.5;
              vrr = true;
              transform = 3;
              positionX = 0;
              positionY = 0;
              workspaces = [
                1
                2
                3
                4
              ];
            }
            {
              name = "eDP-1";
              width = 1920;
              height = 1080;
              refreshRate = 60;
              scale = 1.5;
              vrr = true;
              positionX = 1080;
              positionY = 0;
              workspaces = [
                5
                6
              ];
            }
            {
              name = "DP-6";
              width = 1920;
              height = 1080;
              refreshRate = 75;
              # scale = 1.5;
              vrr = true;
              positionX = 2360;
              positionY = 0;
              workspaces = [
                7
                8
                9
                10
              ];
            }
          ];
        };

        fonts = {
          regular = "Iosevka Etoile";
          monospace = "Iosevka Nerd Font";
        };

        colorscheme = {
          theme = "tokyonight";
          variant = "night";
        };

        programs = { };

        # don't blind me on startup
        startup = [
          {
            spawn = [
              (getExe pkgs.brightnessctl)
              "s"
              "50%"
            ];
          }
        ];

        persist = {
          home.directories = [ "Downloads" ];
        };
      };

      networking.hostId = "c9f3a7de"; # required for zfs

      # touchpad support
      services.libinput.enable = true;

      # thunderbolt support
      services.hardware.bolt.enable = true;

      # disable thumbprint reader
      services.fprintd.enable = false;
    };
}

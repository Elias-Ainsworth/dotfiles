{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    flatten
    getExe
    mkEnableOption
    mkIf
    optionals
    ;
  inherit (config.custom) monitors;
  pamixer = getExe pkgs.pamixer;
  rofiExe = getExe config.programs.rofi.package;
  termExec = cmd: "${config.custom.terminal.package} -e ${cmd}";
  qtile_like = config.custom.hyprland.qtile;
in
{
  options.custom = {
    hyprland = {
      qtile = mkEnableOption "qtile like behavior for workspaces";
    };
  };

  config = mkIf (config.custom.wm == "hyprland") {
    custom.shell.packages = {
      focus-or-run = {
        runtimeInputs = with pkgs; [
          config.wayland.windowManager.hyprland.package
          jq
        ];
        # $1 is string to search for in window title
        # $2 is the command to run if the window isn't found
        text = # sh
          ''
            address=$(hyprctl clients -j | jq -r ".[] | select(.title | contains(\"$1\")) | .address")
            if [ -z "$address" ]; then
              eval "uwsm app -- $2"
            else
              hyprctl dispatch focuswindow "address:$address"
            fi
          '';
      };
    };

    wayland.windowManager.hyprland.settings =
      let
        # exec using uwsm
        uexec = program: "exec, uwsm app -- ${program}";
        workspace_keybinds = flatten (
          (lib.custom.mapWorkspaces (
            { workspace, key, ... }:
            if qtile_like then
              [
                # Switch workspaces with mainMod + [0-9]
                "$mod, ${key}, focusworkspaceoncurrentmonitor, ${workspace}"
                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mod_SHIFT, ${key}, movetoworkspace, ${workspace}"
                "$mod_SHIFT, ${key}, focusworkspaceoncurrentmonitor, ${workspace}"
              ]
            else
              [
                # Switch workspaces with mainMod + [0-9]
                "$mod, ${key}, workspace, ${workspace}"
                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mod_SHIFT, ${key}, movetoworkspace, ${workspace}"
              ]
          ))
            monitors
        );
      in
      {
        bind =
          [
            "$mod, Return, ${uexec (getExe config.custom.terminal.package)}"
            "$mod_SHIFT, Return, ${uexec ''${rofiExe} -show drun -run-command "uwsm app -- {cmd}"''}"
            "$mod, BackSpace, killactive,"
            "$mod, e, ${uexec "nemo ${config.xdg.userDirs.download}"}"
            "$mod_SHIFT, e, ${uexec (termExec "yazi ${config.xdg.userDirs.download}")}"
            "$mod, w, ${uexec (getExe config.programs.chromium.package)}"
            "$mod_SHIFT, w, ${uexec "${getExe config.programs.chromium.package} --incognito"}"
            "$mod, v, ${uexec (termExec "nvim")}"
            "$mod_SHIFT, v, ${uexec (getExe pkgs.custom.shell.rofi-edit-proj)}"
            ''$mod, period, exec, focus-or-run "dotfiles - VSCodium" "codium ${config.home.homeDirectory}/projects/dotfiles"''
            ''$mod_SHIFT, period, exec, focus-or-run "nixpkgs - VSCodium" "codium ${config.home.homeDirectory}/projects/nixpkgs"''

            # exit hyprland
            "ALT, F4, exit,"

            # without the rounding, the blur shows up around the corners
            "CTRL_ALT, Delete, ${uexec (getExe config.custom.rofi-power-menu.package)}"

            # clipboard history
            "$mod_CTRL, v, exec, ${getExe pkgs.custom.shell.rofi-clipboard-history}"

            # reset monitors
            "CTRL_SHIFT, Escape, exec, hypr-monitors"

            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, j, movefocus, u"
            "$mod, k, movefocus, d"

            "$mod_SHIFT, h, movewindow, l"
            "$mod_SHIFT, l, movewindow, r"
            "$mod_SHIFT, k, movewindow, u"
            "$mod_SHIFT, j, movewindow, d"

            "$mod, b, layoutmsg, swapwithmaster"

            # focus the previous / next desktop in the current monitor (DE style)
            "$mod, Left, workspace, m-1"
            "$mod, Right, workspace, m+1"

            # monocle mode
            "$mod, z, fullscreen, 1"

            # fullscreen
            "$mod, f, fullscreen, 0"
            # "$mod_SHIFT, f, fakefullscreen"
            "$mod_SHIFT, f, fullscreenstate, -1 2"

            # floating
            "$mod, g, togglefloating"

            # sticky
            "$mod, s, pin"

            # focus next / previous monitor
            "$mod, Tab, focusmonitor, +1"
            # move to next / previous monitor
            "$mod_SHIFT, Tab, movewindow, mon:+1"

            # classic alt tab in a workspace
            "ALT, Tab, cyclenext"
            "ALT_SHIFT, Tab, cyclenext, prev"

            # toggle between prev and current windows
            "$mod, grave, focuscurrentorlast"

            # switches to the next / previous window of the same class
            "CTRL_ALT_, Tab, exec, wm-same-class next"
            "CTRL_ALT_SHIFT, Tab, exec, wm-same-class prev"

            # picture in picture mode
            "$mod, p, exec, wm-pip"

            # add / remove master windows
            "$mod, m, layoutmsg, addmaster"
            "$mod_SHIFT, m, layoutmsg, removemaster"

            # rotate via switching master orientation
            # "$mod, r, layoutmsg, orientationcycle left top"

            # Scroll through existing workspaces with mainMod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"

            # switching wallpapers or themes
            "$mod, apostrophe, ${uexec "wallpaper rofi"}"
            "$mod_SHIFT, apostrophe, ${uexec "rofi-wallust-theme"}"
            "ALT, apostrophe, ${uexec "wallpaper history"}"

            # special keys
            # "XF86AudioPlay, mpvctl playpause"

            # audio
            ",XF86AudioMute, exec, ${pamixer} -t"
          ]
          # invert windows
          ++ optionals config.custom.hyprland.hypr-darkwindow [ "$mod_shift, i ,invertactivewindow" ]
          ++ workspace_keybinds
          ++ optionals config.custom.backlight.enable [
            ",XF86MonBrightnessDown, exec, ${getExe pkgs.brightnessctl} set 5%-"
            ",XF86MonBrightnessUp, exec, ${getExe pkgs.brightnessctl} set +5%"
          ];
        bindel = [
          # audio
          ",XF86AudioLowerVolume, exec, ${pamixer} -d 5"
          ",XF86AudioRaiseVolume, exec, ${pamixer} -i 5"

          # resizing windows
          "$mod_CTRL, h, resizeactive, -20 0"
          "$mod_CTRL, l, resizeactive, 20 0"
          "$mod_CTRL, k, resizeactive, 0 -20"
          "$mod_CTRL, j, resizeactive, 0 20"
        ];

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod_SHIFT, mouse:272, resizewindow"
        ];
      };
  };
}

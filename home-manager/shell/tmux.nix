{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.custom) colorscheme;
  inherit (lib) optionals;
  inherit (pkgs) playerctl;

  catppuccinPlugin = {
    plugin = pkgs.tmuxPlugins.catppuccin;
    extraConfig = ''
      # Customize tmux catppuccin, needs to be done after plugin is loaded
      set -g @catppuccin_status_background "none"
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
    '';
  };

  kanagawaPlugin = {
    plugin = pkgs.tmuxPlugins.kanagawa;
    extraConfig = ''
      set -g @kanagawa-theme "dragon"
      set -g @kanagawa-cwd-max-dirs "3"
      set -g @kanagawa-cwd-max-chars "20"
      set -g @kanagawa-show-battery false
      set -g @kanagawa-show-powerline true
      set -g @kanagawa-military-time true
      set -g @kanagawa-show-location false
      set -g @kanagawa-refresh-rate 5
      set -g @kanagawa-plugins "playerctl time battery"
      set -g @kanagawa-playerctl-format "{{ title }} - {{ artist }}"
      set -g @kanagawa-show-left-sep 
      set -g @kanagawa-show-right-sep 
    '';
  };
in
{
  home.packages = [
    playerctl
  ];
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-Space";
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    baseIndex = 1; # index panes and windows from 1
    customPaneNavigationAndResize = true; # use vim keys to navigate panes
    sensibleOnTop = true;

    plugins =
      with pkgs.tmuxPlugins;
      [
        tmux-fzf
        vim-tmux-navigator
        yank
      ]
      ++ optionals (colorscheme.theme == "catppuccin") [ catppuccinPlugin ]
      ++ optionals (colorscheme.theme == "kanagawa") [ kanagawaPlugin ];

    extraConfig = # tmux
      ''
        # Allow true color support
        set -ga terminal-overrides ",*:RGB"
        # Allow changing cursor shape
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

        # Keybinds
        bind BSpace confirm kill-session
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        # Saner splitting.
        bind v split-window -h
        bind s split-window -v

        # Activity
        setw -g monitor-activity off
        set -g visual-activity off

        # Automatically set window title
        setw -g automatic-rename on
        set -g set-titles on

        # Transparent tmux background
        set -g window-style "bg=terminal"
        set -g window-active-style "bg=terminal"
      '';
  };

}

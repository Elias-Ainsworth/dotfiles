{ config, ... }:
let
  histFile = "/persist/${config.xdg.configHome}/bash/.bash_history";
in
{
  # NOTE: see shell.nix for shared aliases and initExtra
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = histFile;
    shellAliases = {
      ehistory = "nvim ${histFile}";
    };

    initExtra = # sh
      ''
        # Change cursor with support for inside/outside tmux
        function _set_cursor() {
            if [[ $TMUX = "" ]]; then
              echo -ne $1
            else
              echo -ne "\ePtmux;\e\e$1\e\\"
            fi
        }

        function _set_block_cursor() {
            _set_cursor '\e[2 q'
        }
        function _set_beam_cursor() {
            _set_cursor '\e[6 q'
        }

        # set starting cursor to blinking beam
        # echo -e -n "\x1b[\x35 q"
        _set_beam_cursor
      '';
  };

  custom.persist = {
    home.directories = [ ".config/bash" ];
  };
}

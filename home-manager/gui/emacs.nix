{
  inputs,
  pkgs,
  ...
}:
let
  thornemacs = inputs.thornemacs.packages.${pkgs.system}.default;
in

{
  home.shellAliases = {
    em = "emacs"; # Open Emacs normally
    ec = "emacsclient -c -a ''"; # Open client in a new frame
    et = "emacsclient -t -a ''"; # Open client in terminal
    ek = "emacsclient -e '(kill-emacs)'"; # Kill the Emacs daemon
    es = "emacs --daemon"; # Start Emacs daemonem = "emacs";
  };

  home.packages = [ thornemacs ];
  services.emacs = {
    enable = true;
    package = thornemacs;
    client = {
      enable = true;
    };
  };

  # custom.persist.home.directories = [
  #   ".emacs.d"
  #   ".emacs.d/eln-cache"
  #   ".emacs.d/eshell"
  #   ".config/emacs"
  #   ".local/share/emacs"
  #   ".local/state/emacs"
  # ];
}

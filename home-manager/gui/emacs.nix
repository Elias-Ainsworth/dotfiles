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

  custom.persist.home.directories = [
    "org"
    ".emacs.d"
  ];
}

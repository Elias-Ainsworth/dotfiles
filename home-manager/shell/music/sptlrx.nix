{
  pkgs,
  ...
}:
let
  inherit (pkgs) sptlrx;
in
{
  home = {
    packages = [ sptlrx ];
    file = {
      ".config/sptlrx/config.ron" = {
        force = true;
        text = # yaml
          ''
            player: mpd
            mpd:
                address: 127.0.0.1:6600
                password: ""
          '';
      };
    };
  };
  custom.persist.home.directories = [ ".config/sptlrx" ];
}

{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
in
mkMerge [
  {
    hm = {

      home.packages = [ pkgs.exercism ];

      custom.persist = {
        home.directories = [ ".config/exercism" ];
      };
    };
  }

  # setup auth token for gh if sops is enabled
  (mkIf config.custom.sops.enable {
    sops.secrets.exercism_token.owner = user;

    hm =
      { lib, ... }:
      {
        home.activation.postInstallScript =
          lib.hm.dag.entryAfter [ "writeBoundary" ] # sh
            ''
              ${pkgs.exercism}/bin/exercism --version
            '';
      };
  })
]

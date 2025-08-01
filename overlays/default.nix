{
  inputs,
  pkgs,
  ...
}:
let
  # include generated sources from nvfetcher
  sources = import ./generated.nix {
    inherit (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
in
{
  nixpkgs.overlays = [
    (_: prev: {
      # include nixpkgs stable
      stable = import inputs.nixpkgs-stable {
        inherit (prev.pkgs) system;
        config.allowUnfree = true;
      };

      # include custom packages
      custom =
        (prev.custom or { })
        // {
          inherit (sources) yazi-plugins yazi-time-travel;
        }
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        });

      # nixos-small logo looks like ass
      fastfetch = prev.fastfetch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./fastfetch-nixos-old-small.patch ];
      });

      # add default font to silence null font errors
      lsix = prev.lsix.overrideAttrs (o: {
        postFixup = # sh
          ''
            substituteInPlace $out/bin/lsix \
              --replace-fail '#fontfamily=Mincho' 'fontfamily="JetBrainsMono-NF-Regular"'
            ${o.postFixup}
          '';
      });

      # fix nix package count for nitch
      nitch = prev.nitch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./nitch-nix-pkgs-count.patch ];
      });

      # use latest for namespace functionality
      # https://github.com/LGFae/swww/issues/419
      swww =
        assert (
          pkgs.lib.assertMsg (pkgs.lib.versionOlder prev.swww.version "0.10.4") "swww updated, remove overlay"
        );
        prev.swww.overrideAttrs (
          _o:
          sources.swww
          // {
            # creating an overlay for buildRustPackage overlay
            # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
            cargoDeps = prev.rustPlatform.importCargoLock {
              lockFile = "${sources.swww.src}/Cargo.lock";
              allowBuiltinFetchGit = true;
            };
          }
        );

      # wallust = prev.wallust.overrideAttrs (
      #   sources.wallust
      #   // {
      #     # creating an overlay for buildRustPackage overlay
      #     # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
      #     cargoDeps = prev.rustPlatform.importCargoLock {
      #       lockFile = sources.wallust.src + "/Cargo.lock";
      #       allowBuiltinFetchGit = true;
      #     };
      #   }
      # );

      # nsig keeps breaking, so use updated version from github
      yt-dlp = prev.yt-dlp.overrideAttrs sources.yt-dlp;
    })
  ];
}

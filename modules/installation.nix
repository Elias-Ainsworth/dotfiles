{
  perSystem =
    { pkgs, ... }:
    let
      repo_url = "https://raw.githubusercontent.com/elias-ainsworth/dotfiles";
    in
    {
      packages = rec {
        default = install;

        install = pkgs.writeShellApplication {
          name = "thorneos-install";
          runtimeInputs = [ pkgs.curl ];
          text = # sh
            "sh <(curl -L ${repo_url}/main/install.sh)";
        };

        recover = pkgs.writeShellApplication {
          name = "thorneos-recover";
          runtimeInputs = [ pkgs.curl ];
          text = # sh
            "sh <(curl -L ${repo_url}/main/recover.sh)";
        };
      };
    };
}

{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
in
{
  options.custom = {
    cloudflared.enable = mkEnableOption "Enable Cloudflared tunnel" // {
      default = host == "t440";
    };
  };

  config = mkIf config.custom.cloudflared.enable {
    services.cloudflared = {
      enable = true;
      tunnels.pilum-murialis = {
        credentialsFile = config.sops.secrets.cloudflarePilum.path;
        ingress = {
          "pilum-murialis.xyz" = "http://localhost:80";
          "default" = "404";
        };
      };
    };

    # Conditionally add sops.secret only if sops is enabled
    sops.secrets = optionalAttrs config.custom.sops.enable {
      cloudflarePilum = {
        sopsFile = ./cloudflare-tunnel.json;
      };
    };

    hm.custom.persist = {
      home.cache.directories = [ ".cloudflared" ];
    };
  };
}

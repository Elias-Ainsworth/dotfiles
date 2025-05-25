{
  config,
  lib,
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
      tunnels."665666e7-aae8-4050-879f-c58bea8e3556" = {
        credentialsFile = config.sops.secrets.cloudflarePilum.path;
        ingress = {
          "pilum-murialis.xyz" = "http://localhost:80";
          "www.pilum-murialis.xyz" = "http://localhost:80"; # optional
          # "*" = "http_status:404";
        };
        default = "http_status:404";
      };
    };

    # Conditionally add sops.secret only if sops is enabled
    sops.secrets = {
      cloudflarePilum = {
        sopsFile = ./cloudflare-tunnel.json;
        format = "json";
        key = "";
      };
    };

    hm.custom.persist = {
      home.cache.directories = [ ".cloudflared" ];
    };
  };
}

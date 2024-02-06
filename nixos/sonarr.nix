{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  sonarr-ical-sync = pkgs.writeShellApplication {
    name = "sonarr-ical-sync";
    runtimeInputs = with pkgs; [
      curl
      netlify-cli
    ];
    text =
      let
        inherit (config.sops) secrets;
      in
      ''
        outDir=/tmp/sonarr-ical-sync
        mkdir -p "$outDir"

        SONARR_API_KEY="$(cat ${secrets.sonarr_api_key.path})"
        curl "http://localhost:8989/feed/calendar/Sonarr.ics?apikey=$SONARR_API_KEY" -o "$outDir/Sonarr.ics"

        NETLIFY_SITE_ID="$(cat ${secrets.netlify_site_id.path})" netlify deploy --dir="$outDir" --prod
      '';
  };
in
lib.mkIf config.custom-nixos.bittorrent.enable (
  lib.mkMerge [
    {
      services = {
        sonarr = {
          enable = true;
          inherit user;
        };

        # for indexers
        prowlarr.enable = true;
      };

      custom-nixos.persist = {
        root.directories = [
          "/var/lib/sonarr/.config/NzbDrone"
          "/var/lib/private/prowlarr"
        ];
        home.directories = [ ".config/netlify" ];
      };
    }

    # only setup sonarr-ical-sync if sops is enabled
    (lib.mkIf config.custom-nixos.sops.enable {
      # allow sonarr to read secret keys
      sops.secrets = {
        sonarr_api_key.owner = user;
        netlify_site_id.owner = user;
      };

      # setup cron job to sync sonarr ical with google calendar
      # https://www.codyhiar.com/blog/repeated-tasks-with-systemd-service-timers-on-nixos/
      # timer format examples can be found at man systemd.time
      systemd = {
        services.sonarr-ical-sync = {
          serviceConfig.Type = "oneshot";
          serviceConfig.User = user;
          script = lib.getExe sonarr-ical-sync;
        };
        timers.sonarr-ical-sync = {
          wantedBy = [ "timers.target" ];
          partOf = [ "sonarr-ical-sync.service" ];
          timerConfig = {
            # every 6h at 39min past the hour
            OnCalendar = "00/6:39:00";
            Unit = "sonarr-ical-sync.service";
          };
        };
      };
    })
  ]
)

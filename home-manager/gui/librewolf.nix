{
  config,
  inputs,
  host,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (lib) concatStringsSep mkIf optionals;
  configPath = ".config/.librewolf";
in
mkIf (!config.custom.headless) {
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf.overrideAttrs (o: {
      # launch librewolf with user profile
      buildCommand =
        o.buildCommand
        + ''
          wrapProgram "$out/bin/librewolf" \
            --set 'HOME' '${config.xdg.configHome}' \
            --append-flags "${
              concatStringsSep " " (
                [
                  "--name librewolf"
                  # load librewolf profile with same name as user
                  "--profile ${config.home.homeDirectory}/${configPath}/${user}"
                ]
                ++ [
                  # launch with the following urls:
                  "https://discordapp.com/channels/@me"
                ]
                ++ optionals (host == "desktop") [
                  "https://web.whatsapp.com" # requires access via local network
                  "http://localhost:9091" # transmission
                ]
              )
            }"
        '';
    });

    inherit configPath;

    profiles.${user} = {
      # TODO: define keyword searches here?
      # search.engines = [ ];

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        bitwarden
        darkreader
        screenshot-capture-annotate
        sponsorblock
        ublock-origin
      ];

      settings = {
        "privacy.clearOnShutdown_v2.cache" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = # css
        ''
          /* remove useless urlbar padding */
          #customizableui-special-spring1 { display:none }
          #customizableui-special-spring2 { display:none }

          /* remove all tabs button and window controls */
          #alltabs-button { display:none }
          .titlebar-spacer { display:none }
          .titlebar-buttonbox-container { display:none }
        '';
    };
  };

  custom.persist = {
    home.directories = [
      ".cache/librewolf"
      configPath
    ];
  };
}

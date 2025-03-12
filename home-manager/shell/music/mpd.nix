{
  config,
  lib,
  ...
}:
let
  inherit (config.xdg.userDirs) music;
  inherit (lib) mkIf;

  musicDirectory = music;
in
{
  config = mkIf config.custom.mpd.enable {

    services = {
      mpdris2.enable = true;
      playerctld.enable = true;
      mpd = {
        enable = true;
        inherit musicDirectory;
        dataDir = "${config.home.homeDirectory}/.config/mpd";
        extraConfig = ''
          auto_update           "yes"
          restore_paused        "yes"
          audio_output {
            type "pulse"
            name "Pulseaudio"
          }
          audio_output {
          	type                "fifo"
          	name                "Visualizer"
          	format              "44100:16:2"
          	path                "/tmp/mpd.fifo"
          }
        '';
        network.startWhenNeeded = true;
      };
    };
  };
}

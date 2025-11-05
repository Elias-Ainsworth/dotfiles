{
  flake.nixosModules.music =
    { config, ... }:
    let
      musicDir = "/persist${config.hj.directory}/Music";
    in
    {
      services = {
        mpd = {
          enable = true;
          musicDirectory = musicDir;
          dataDir = "/persist${config.hj.directory}/.config/mpd";
          extraConfig = ''
            auto_update           "yes"
            restore_paused        "yes"
            audio_output {
              type "pulse"
              name "Pulseaudio"
            	format              "44100:16:2"
            }
            audio_output {
            	type                "fifo"
            	name                "Visualizer"
            	format              "44100:16:2"
            	path                "/tmp/mpd.fifo"
            }
          '';
          startWhenNeeded = true;
        };
        playerctld.enable = true;

        # MPDRIS2
        # environment.systemPackages = [ pkgs.mpdris2-rs ];
      };
    };
}

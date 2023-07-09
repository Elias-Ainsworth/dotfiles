{
  pkgs,
  user,
  config,
  ...
}: {
  config = {
    home-manager.users.${user} = {
      home.packages = [pkgs.cava];
    };

    iynaix.wallust.entries.cava = {
      enable = config.iynaix.wallust.cava;
      text = ''
        [general]
        ; framerate = 60
        autosens = 0
        sensitivity = 50

        ; bars = 0
        ; bar_width = 2
        ; bar_spacing = 1
        ; bar_height = 32

        ; bar_width = 20
        ; bar_spacing = 5

        ; lower_cutoff_freq = 50
        ; higher_cutoff_freq = 10000

        ; sleep_timer = 0

        [input]
        method = pulse
        ; source = auto

        ; method = alsa
        ; source = hw:Loopback,1

        ; method = fifo
        ; source = /tmp/mpd.fifo
        ; sample_rate = 44100
        ; sample_bits = 16

        ; method = shmem
        ; source = /squeezelite-AA:BB:CC:DD:EE:FF

        ; method = portaudio
        ; source = auto


        [output]
        method = ncurses

        ; orientation = bottom

        ; channels = stereo
        ; mono_option = average
        ; reverse = 0

        ; raw_target = /dev/stdout

        ; data_format = binary

        ; bit_format = 16bit

        ; ascii_max_range = 1000

        ; bar_delimiter = 59
        ; frame_delimiter = 10

        ; sdl_width = 1000
        ; sdl_height = 500
        ; sdl_x = -1
        ; sdl_y= -1

        ; xaxis = none

        [color]
        ; background = default
         foreground = red

        # SDL only support hex code colors, these are the default:
        ; background = '#111111'
        ; foreground = '#33cccc'


        gradient = 1
        gradient_count = 6
        gradient_color_1 = "{color3}"
        gradient_color_2 = "{color4}"
        gradient_color_3 = "{color5}"
        gradient_color_4 = "{color1}"
        gradient_color_5 = "{color1}"
        ; gradient_color_6 = '#cc8033'
        ; gradient_color_7 = '#cc5933'
        ; gradient_color_8 = '#cc3333'

        [smoothing]

        # Percentage value for integral smoothing. Takes values from 0 - 100.
        # Higher values means smoother, but less precise. 0 to disable.
        # DEPRECATED as of 0.8.0, use noise_reduction instead
        ; integral = 77

        # Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.
        ; monstercat = 0
        ; waves = 0

        # Set gravity percentage for "drop off". Higher values means bars will drop faster.
        # Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".
        # DEPRECATED as of 0.8.0, use noise_reduction instead
        ; gravity = 100


        # In bar height, bars that would have been lower that this will not be drawn.
        # DEPRECATED as of 0.8.0
        ; ignore = 0

        # Noise reduction, float 0 - 1. default 0.77
        # the raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth
        # 1 will be very slow and smooth, 0 will be fast but noisy.
        ; noise_reduction = 0.77

        [eq]

        # This one is tricky. You can have as much keys as you want.
        # Remember to uncomment more then one key! More keys = more precision.
        # Look at readme.md on github for further explanations and examples.
        ; 1 = 1 # bass
        ; 2 = 1
        ; 3 = 1 # midtone
        ; 4 = 1
        ; 5 = 1 # treble
      '';
      target = "~/.config/cava/config";
    };
  };
}

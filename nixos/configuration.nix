{
  pkgs,
  host,
  ...
}:
{
  networking.hostName = host; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # seems to break virtual-console service because it can't find the font
    # https://github.com/NixOS/nixpkgs/issues/257904
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true; # use xkb.options in tty.
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    # # week starts on a Monday, for fuck's sake
    # LC_TIME = "en_GB.UTF-8";
    # Sorry Grandmaster, but the week starts on a Sunday.
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    # bye bye xterm
    excludePackages = [ pkgs.xterm ];
  };

  # enable sysrq in case for kernel panic
  # boot.kernel.sysctl."kernel.sysrq" = 1;

  # use dbus broker as the default implementation
  services.dbus.implementation = "broker";

  # enable opengl
  hardware.graphics.enable = true;

  # zram
  zramSwap.enable = true;

  # do not change this value
  system.stateVersion = "23.05";
}

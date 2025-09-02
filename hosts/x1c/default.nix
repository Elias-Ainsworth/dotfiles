_: {
  custom = {
    distrobox.enable = true;
    virtualization.enable = true;
    qmk.enable = true;
  };

  networking.hostId = "ec7351ab"; # required for zfs

  services = {
    # touchpad support
    libinput.enable = true;

    # disable thumbprint reader
    fprintd.enable = false;

    # vlc cast support
    avahi.enable = true;

    # thunderbolt support
    hardware.bolt.enable = true;
  };
}
